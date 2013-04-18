# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/jwm/jwm-2.0.1.ebuild,v 1.10 2012/01/31 23:02:05 jer Exp $

EAPI=3
inherit eutils

DESCRIPTION="Very fast and lightweight still powerful window manager for X"
HOMEPAGE="http://joewing.net/programs/jwm/"
SRC_URI="http://joewing.net/programs/jwm/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 hppa ppc x86"
IUSE="bidi debug jpeg png truetype xinerama xpm"

RDEPEND="xpm? ( x11-libs/libXpm )
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp
	truetype? ( x11-libs/libXft )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	bidi? ( dev-libs/fribidi )
	dev-libs/expat"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nostrip.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		$(use_enable xpm) \
		$(use_enable bidi fribidi) \
		--enable-shape \
		--enable-xrender
}

src_install() {
	dodir /usr/bin
	dodir /etc
	dodir /usr/share/man
	emake BINDIR="${D}/usr/bin" SYSCONF="${D}/etc" \
		MANDIR="${D}/usr/share/man" install || die
	rm "${D}"/etc/system.jwmrc

	echo "#!/bin/sh" > jwm
	echo "exec /usr/bin/jwm" >> jwm
	exeinto /etc/X11/Sessions
	doexe jwm

	dodoc README example.jwmrc todo.txt
}

pkg_postinst() {
	einfo "Put an appropriate configuration file in /etc/system.jwmrc"
	einfo "or in ~/.jwmrc."
	einfo "An example file can be found in ${EROOT}/usr/share/doc/${PF}/"
}
