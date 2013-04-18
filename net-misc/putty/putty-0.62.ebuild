# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/putty/putty-0.62.ebuild,v 1.6 2012/05/21 20:01:14 ssuominen Exp $

EAPI="4"

inherit autotools eutils toolchain-funcs

DESCRIPTION="UNIX port of the famous Telnet and SSH client"
HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/putty/"
SRC_URI="http://the.earth.li/~sgtatham/${PN}/latest/${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="doc ipv6 kerberos"

RDEPEND="
	!net-misc/pssh
	dev-libs/glib
	kerberos? ( virtual/krb5 )
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
"

src_prepare() {
	cd "${S}"/unix || die "cd unix failed"
	sed \
		-i configure.ac \
		-e '/^AM_PATH_GTK(/d' \
		-e 's|-Wall -Werror||g' || die "sed failed"
	eautoreconf
}

src_configure() {
	cd "${S}"/unix || die "cd failed"
	econf $(use_with kerberos gssapi)
}

src_compile() {
	cd "${S}"/unix || die "cd unix failed"
	emake $(use ipv6 || echo COMPAT=-DNO_IPV6)
}

src_install() {
	if use doc; then
		dodoc doc/puttydoc.txt
		dohtml doc/*.html
	fi

	cd "${S}"/unix
	default

	# install desktop file provided by Gustav Schaffter in #49577
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry putty PuTTY putty Network
}
