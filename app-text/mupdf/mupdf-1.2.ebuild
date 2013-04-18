# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mupdf/mupdf-1.2.ebuild,v 1.2 2013/03/25 09:50:29 xmw Exp $

EAPI=4

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://mupdf.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-source.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X vanilla"

RDEPEND="media-libs/freetype:2
	media-libs/jbig2dec
	>=media-libs/openjpeg-1.5
	virtual/jpeg
	X? ( x11-libs/libX11
		x11-libs/libXext )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}-source

src_prepare() {
	rm -rf thirdparty || die

	epatch "${FILESDIR}"/${PN}-1.1_p20121127-buildsystem.patch
	epatch "${FILESDIR}"/${PN}-1.1_p20121127-desktop-integration.patch
	epatch "${FILESDIR}"/${PN}-1.2-mubusy_rename_fix.patch

	if ! use vanilla ; then
		epatch "${FILESDIR}"/${PN}-1.1_rc1-zoom-2.patch
	fi
}

src_compile() {
	use X || my_nox11="NOX11=yes MUPDF= "

	emake CC="$(tc-getCC)" AR="$(tc-getAR)" OS=Linux \
		build=debug verbose=true ${my_nox11}
}

src_install() {
	emake prefix="${ED}usr" libdir="${ED}usr/$(get_libdir)" \
		build=debug verbose=true ${my_nox11} install

	insinto /usr/include
	doins pdf/mupdf{,-internal}.h
	doins fitz/fitz{,-internal}.h
	doins xps/muxps{,-internal}.h

	insinto /usr/$(get_libdir)/pkgconfig
	doins debian/mupdf.pc

	if use X ; then
		domenu debian/mupdf.desktop
		doicon debian/mupdf.xpm
	fi
	dodoc CHANGES README doc/{example.c,overview.txt}
}
