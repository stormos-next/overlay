# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/autofs/autofs-5.0.6-r5.ebuild,v 1.1 2011/12/17 03:45:15 pva Exp $

EAPI="4"
inherit eutils multilib autotools linux-info

DESCRIPTION="Kernel based automounter"
HOMEPAGE="http://www.linux-consulting.com/Amd_AutoFS/autofs.html"
PATCH_VER="1"
[[ -n ${PATCH_VER} ]] && \
	PATCHSET_URI="mirror://gentoo/${P}-patches-${PATCH_VER}.tar.lzma"
SRC_URI="mirror://kernel/linux/daemons/${PN}/v5/${P}.tar.bz2
	${PATCHSET_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="hesiod ldap sasl"

# USE="sasl" adds SASL support to the LDAP module which will not be build. If
# SASL support should be available, please add "ldap" to the USE flags.
REQUIRED_USE="sasl? ( ldap )"

# currently, sasl code assumes the presence of kerberosV
RDEPEND="
	hesiod? ( net-dns/hesiod )
	ldap? ( >=net-nds/openldap-2.0
		sasl? ( dev-libs/cyrus-sasl
			dev-libs/libxml2
			virtual/krb5 ) )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"

src_prepare() {
	# Upstream's patchset
	if [[ -n ${PATCH_VER} ]]; then
		EPATCH_SUFFIX="patch" \
			epatch "${WORKDIR}"/patches
	fi

	# Fix for bug #210762
	# Upstream reference: http://thread.gmane.org/gmane.linux.kernel.autofs/4203
	epatch "${FILESDIR}"/${PN}-5.0.3-heimdal.patch

	# Accumulated fixes for bugs
	#    #154797: Respect CC and CFLAGS
	#    #253412: Respect LDFLAGS
	#    #247969: Link order for --as-needed
	epatch "${FILESDIR}"/${P}-respect-user-flags-and-fix-asneeded-r2.patch

	# Upstream reference: http://thread.gmane.org/gmane.linux.kernel.autofs/5371
	epatch "${FILESDIR}"/${PN}-5.0.5-fix-install-deadlink.patch

	# Upstream reference: http://thread.gmane.org/gmane.linux.kernel.autofs/6039
	# Disable LDAP specific code if USE="-ldap", let's see what upstream says...
	epatch "${FILESDIR}"/${PN}-5.0.5-fix-building-without-ldap.patch

	# https://bugs.gentoo.org/show_bug.cgi?id=361899
	epatch "${FILESDIR}"/${PN}-5.0.5-add-missing-endif-HAVE_SASL-in-modules-lookup_ldap.c.patch

	# https://bugs.gentoo.org/show_bug.cgi?id=381315
	epatch "${FILESDIR}"/${P}-revert-ldap.patch
	eautoreconf
}

src_configure() {
	# work around bug #355975 (mount modifies timestamp of /etc/mtab)
	# with >=sys-apps/util-linux-2.19,
	addpredict "/etc/mtab"

	# --with-confdir is for bug #361481
	# --with-mapdir is for bug #385113
	# for systemd support (not enabled yet):
	#   --with-systemd
	#   --disable-move-mount: requires kernel >=2.6.39
	econf \
		--with-confdir=/etc/conf.d \
		--with-mapdir=/etc/autofs \
		$(use_with ldap openldap) \
		$(use_with sasl) \
		$(use_with hesiod) \
		--enable-ignore-busy
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README* CHANGELOG CREDITS COPYRIGHT INSTALL

	# kernel patches
	docinto patches
	dodoc patches/${PN}4-2.6.??{,.?{,?}}-v5-update-????????.patch

	newinitd "${FILESDIR}"/autofs5.initd autofs
	insinto etc/autofs
	newins "${FILESDIR}"/autofs5-auto.master auto.master
}

pkg_postinst() {
	if kernel_is -lt 2 6 30; then
		elog "This version of ${PN} requires a kernel with autofs4 supporting"
		elog "protocol version 5.00. Patches for kernels older than 2.6.30 have"
		elog "been installed into"
		elog "${EROOT}usr/share/doc/${P}/patches."
		elog "For further instructions how to patch the kernel, please refer to"
		elog "${EROOT}usr/share/doc/${P}/INSTALL."
		elog
	fi
	elog "If you plan on using autofs for automounting remote NFS mounts,"
	elog "please check that both portmap (or rpcbind) and rpc.statd/lockd"
	elog "are running."
}
