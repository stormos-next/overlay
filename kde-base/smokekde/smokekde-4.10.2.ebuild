# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smokekde/smokekde-4.10.2.ebuild,v 1.1 2013/04/06 00:04:33 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - KDE bindings"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="attica debug kate okular semantic-desktop"

DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	$(add_kdebase_dep smokeqt)
	attica? ( dev-libs/libattica )
	kate? ( $(add_kdebase_dep kate) )
	okular? ( $(add_kdebase_dep okular) )
	semantic-desktop? ( $(add_kdebase_dep kdepimlibs) )
"
RDEPEND="${DEPEND}"

add_blocker smoke

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_disable kate)
		$(cmake-utils_use_with okular)
		$(cmake-utils_use_with semantic-desktop Akonadi)
		$(cmake-utils_use_with semantic-desktop KdepimLibs)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
	)
	kde4-base_src_configure
}
