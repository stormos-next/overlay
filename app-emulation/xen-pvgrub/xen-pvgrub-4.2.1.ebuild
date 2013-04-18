# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen-pvgrub/xen-pvgrub-4.2.1.ebuild,v 1.2 2013/01/30 14:12:30 idella4 Exp $

EAPI="4"

inherit flag-o-matic eutils multilib toolchain-funcs

XEN_EXTFILES_URL="http://xenbits.xensource.com/xen-extfiles"
LIBPCI_URL=ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
GRUB_URL=mirror://gnu-alpha/grub
SRC_URI="
		http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz
		$GRUB_URL/grub-0.97.tar.gz
		$XEN_EXTFILES_URL/zlib-1.2.3.tar.gz
		$LIBPCI_URL/pciutils-2.2.9.tar.bz2
		$XEN_EXTFILES_URL/lwip-1.3.0.tar.gz
		$XEN_EXTFILES_URL/newlib/newlib-1.16.0.tar.gz"

S="${WORKDIR}/xen-${PV}"

DESCRIPTION="allows to boot Xen domU kernels from a menu.lst laying inside guest filesystem"
HOMEPAGE="http://xen.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags"

DEPEND="sys-devel/gettext
	sys-devel/gcc"

RDEPEND=">=app-emulation/xen-4.2.1"

src_prepare() {

	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
	fi

	#Substitute for internal downloading
	cp $DISTDIR/zlib-1.2.3.tar.gz \
		$DISTDIR/pciutils-2.2.9.tar.bz2 \
		$DISTDIR/lwip-1.3.0.tar.gz \
		$DISTDIR/newlib-1.16.0.tar.gz \
		$DISTDIR/grub-0.97.tar.gz \
		./stubdom/ || die "files not coped to stubdom"
	# Note: tip to patch grub gentoo style, for review soon. This is around 1/3.
#	cp "${WORKDIR}"/patch/{00[3-6]_all_grub*,010_all_grub*,01[3-9]_all_grub*,0[6-7]0_all_grub*} \
#		"${WORKDIR}"/patch/{110_all_grub*,300_all_grub*} \
#		 stubdom/grub.patches/ || die
	einfo "files copied to stubdom"

	# Patch the unmergeable newlib, fix most of the leftover gcc QA issues
	cp "${FILESDIR}"/newlib-implicits.patch stubdom || die

	# Patch stubdom/Makefile to patch insource newlib & prevent internal downloading
	epatch "${FILESDIR}"/${P/-pvgrub/}-externals.patch

	# Drop .config and Fix gcc-4.6
	epatch 	"${FILESDIR}"/${PN/-pvgrub/}-4-fix_dotconfig-gcc.patch

	# fix jobserver in Makefile
	epatch "${FILESDIR}"/${PN/-pvgrub/}-4.2.0-jserver.patch
}

src_compile() {
	use custom-cflags || unset CFLAGS
	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake CC="$(tc-getCC)" LD="$(tc-getLD)" -C tools/include

	# TODO; fix those -j1
	if use x86; then
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" \
		XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub
	elif use amd64; then
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" \
		XEN_TARGET_ARCH="x86_64" -C stubdom pv-grub
		if use multilib; then
			multilib_toolchain_setup x86
			emake XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub
		fi
	fi
}

src_install() {
	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" DESTDIR="${D}" -C stubdom install-grub
		if use multilib; then
			emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub
		fi
	fi
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " http://www.gentoo.org/doc/en/xen-guide.xml"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"
}
