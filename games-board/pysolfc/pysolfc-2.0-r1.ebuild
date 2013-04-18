# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/pysolfc/pysolfc-2.0-r1.ebuild,v 1.4 2013/02/14 12:08:15 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )
PYTHON_REQ_USE="tk"

inherit eutils python-r1 distutils-r1 games

MY_PN=PySolFC
SOL_URI="mirror://sourceforge/${PN}"

DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net/"
SRC_URI="${SOL_URI}/${MY_PN}-${PV}.tar.bz2
	extra-cardsets? ( ${SOL_URI}/${MY_PN}-Cardsets-${PV}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="extra-cardsets minimal +sound"

S=${WORKDIR}/${MY_PN}-${PV}

RDEPEND="sound? ( dev-python/pygame )
	!minimal? ( dev-python/imaging[tk]
		dev-tcltk/tktable )"

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i \
		-e "/pysol.desktop/d" \
		-e "s:share/icons:share/pixmaps:" \
		-e "s:data_dir =.*:data_dir = \'share/games/${PN}\':" \
		setup.py || die

	# avoid installing pysol.py into /usr/bin
	sed -i \
		-e '/scripts/d' \
		setup.py || die
}

src_prepare() {
	distutils-r1_src_prepare
}

# Avoid running emake on shipped Makefile
src_compile() { :; }

python_install_all() {
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe pysol.py
	python_replicate_script "${ED}${GAMES_DATADIR}"/${PN}/pysol.py

	games_make_wrapper ${PN} ./pysol.py "${GAMES_DATADIR}"/${PN}

	make_desktop_entry ${PN} "PySol Fan Club Edition" pysol01

	if use extra-cardsets; then
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r "${WORKDIR}"/${MY_PN}-Cardsets-${PV}/*
	fi

	doman docs/*.6
	dohtml docs/*.html

	dodoc AUTHORS README

	docinto docs
	dodoc docs/README*

	prepgamesdirs
}

src_install() {
	distutils-r1_src_install
}
