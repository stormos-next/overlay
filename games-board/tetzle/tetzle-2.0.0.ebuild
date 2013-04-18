# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/tetzle/tetzle-2.0.0.ebuild,v 1.4 2013/03/02 21:13:57 hwoarang Exp $

EAPI=2
inherit qt4-r2 games

DESCRIPTION="A jigsaw puzzle game that uses tetrominoes for the pieces"
HOMEPAGE="http://gottcode.org/tetzle/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-qt/qtgui-4.7:4
	>=dev-qt/qtopengl-4.7:4"

DOCS="ChangeLog CREDITS"

src_prepare() {
	sed -i -e "s:appdir + \"/../share/\":\"${GAMES_DATADIR}/\":" src/locale_dialog.cpp || die
	sed -i -e "/qm.path/s:\$\$PREFIX/share:${GAMES_DATADIR}:" ${PN}.pro || die
}

src_configure() {
	eqmake4 BINDIR="${GAMES_BINDIR/\/usr}" PREFIX="/usr"
}

src_install() {
	qt4-r2_src_install
	prepgamesdirs
}
