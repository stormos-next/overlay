# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/luola/luola-1.3.2.ebuild,v 1.1 2013/02/17 03:06:02 hasufell Exp $

EAPI=5
inherit eutils autotools gnome2-utils games

DESCRIPTION="A 2D multiplayer arcade game resembling V-Wing"
HOMEPAGE="http://luolamies.org/software/luola/"
SRC_URI="http://luolamies.org/software/luola/${P}.tar.gz
	http://www.luolamies.org/software/luola/stdlevels-6.0.tar.gz
	http://www.luolamies.org/software/luola/nostalgia-1.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[X,audio,joystick,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlink.patch
	eautoreconf
}

src_configure() {
	egamesconf --enable-sound
}

src_install() {
	emake DESTDIR="${D}" install
	insinto "${GAMES_DATADIR}"/${PN}/levels
	doins "${WORKDIR}"/*.{lev,png}
	dodoc AUTHORS ChangeLog DATAFILE FAQ LEVELFILE README TODO \
		RELEASENOTES.txt ../README.Nostalgia
	newdoc ../README README.stdlevels
	doicon -s 64 luola.png
	make_desktop_entry luola Luola
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
