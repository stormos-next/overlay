# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/vym/vym-2.3.11.ebuild,v 1.4 2013/03/02 23:54:15 hwoarang Exp $

EAPI=5
inherit eutils qt4-r2

DESCRIPTION="View Your Mind, a mindmap tool"
HOMEPAGE="http://www.insilmaril.de/vym/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

VYM_LINGUAS=( cs_CZ de_DE es fr ia it pt_BR ru sv zh_CN zh_TW )
IUSE+=" ${VYM_LINGUAS[@]/#/linguas_}"

DEPEND="
	dev-qt/qtdbus:4
	dev-qt/qtgui:4[qt3support]
	dev-qt/qtsvg:4
"
RDEPEND="
	${DEPEND}
	app-arch/zip
"

DOCS="README.txt"

src_prepare() {
	local lingua
	for lingua in ${VYM_LINGUAS[@]}; do
		if ! use linguas_${lingua}; then
			sed -i \
				"/lang\/vym_${lingua}.ts/d" \
				CMakeLists.txt || die
			rm -r lang/vym_${lingua}.ts || die
		fi
	done
	sed -i \
		-e '/lang\/vym_en.ts/d' \
		CMakeLists.txt || die
	rm -r lang/vym_en.ts || die
}

src_configure() {
	eqmake4 PREFIX=/usr DOCDIR=/usr/share/doc/${PF}
}

src_install() {
	qt4-r2_src_install
	doman doc/vym.1.gz
	make_desktop_entry vym vym /usr/share/vym/icons/vym.png Education
}
