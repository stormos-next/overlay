# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/apache-tools/apache-tools-2.4.4-r1.ebuild,v 1.1 2013/03/25 03:21:12 patrick Exp $

EAPI="3"
inherit flag-o-matic eutils multilib

DESCRIPTION="Useful Apache tools - htdigest, htpasswd, ab, htdbm"
HOMEPAGE="http://httpd.apache.org/"
SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc64-solaris ~x64-solaris"
IUSE="ssl"
RESTRICT="test"

RDEPEND="=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	dev-libs/libpcre
	ssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/httpd-${PV}"

src_configure() {
	local myconf=""

	# Instead of filtering --as-needed (bug #128505), append --no-as-needed
	append-ldflags $(no-as-needed)

	use ssl && myconf+=" --with-ssl=${EPREFIX}/usr --enable-ssl"

	# econf overwrites the stuff from config.layout, so we have to put them into
	# our myconf line too
	econf \
		--libexecdir=/usr/$(get_libdir)/apache2/modules \
		--sbindir="${EPREFIX}"/usr/sbin \
		--with-perl="${EPREFIX}"/usr/bin/perl \
		--with-expat="${EPREFIX}"/usr \
		--with-z="${EPREFIX}"/usr \
		--with-apr="${EPREFIX}"/usr \
		--with-apr-util="${EPREFIX}"/usr \
		--with-pcre="${EPREFIX}"/usr \
		${myconf}
}

src_compile() {
	cd support || die
	emake
}

src_install () {
	cd support || die

	make DESTDIR="${D}" install

	# install manpages
	doman "${S}"/docs/man/{dbmmanage,htdigest,htpasswd,htdbm,ab,logresolve}.1 \
		"${S}"/docs/man/{htcacheclean,rotatelogs}.8

	# Providing compatiblity symlinks for #177697 (which we'll stop to install
	# at some point).
	pushd "${ED}"/usr/sbin/ >/dev/null
	for i in *; do
		dosym /usr/sbin/${i} /usr/sbin/${i}2
	done
	popd "${ED}"/usr/sbin/ >/dev/null

	# Provide a symlink for ab-ssl
	if use ssl; then
		dosym /usr/bin/ab /usr/bin/ab-ssl
		dosym /usr/bin/ab /usr/bin/ab2-ssl
	fi

	dodoc "${S}"/CHANGES
}
