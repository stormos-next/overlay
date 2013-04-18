# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/peg-e/peg-e-1.1.0.ebuild,v 1.4 2013/03/02 21:12:54 hwoarang Exp $

EAPI=2
inherit eutils qt4-r2 games

DESCRIPTION="A peg solitaire game"
HOMEPAGE="http://gottcode.org/peg-e/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin ${PN} || die
	doicon icons/${PN}.png
	domenu icons/${PN}.desktop
	dodoc README
	prepgamesdirs
}
