# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimono/kimono-4.10.1.ebuild,v 1.4 2013/04/01 13:06:19 ago Exp $

EAPI=5

inherit kde4-base mono

DESCRIPTION="C# bindings for KDE"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="akonadi debug plasma semantic-desktop"

DEPEND="
	dev-lang/mono
	$(add_kdebase_dep qyoto 'webkit')
	$(add_kdebase_dep smokeqt)
	$(add_kdebase_dep smokekde 'semantic-desktop=')
	plasma? ( $(add_kdebase_dep smokeqt 'webkit') )
"
RDEPEND="${DEPEND}"

# Split from kdebindings-csharp in 4.7
add_blocker kdebindings-csharp

src_prepare() {
	kde4-base_src_prepare

	sed -i "/add_subdirectory( examples )/ s:^:#:" plasma/CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_disable plasma)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		-DWITH_Soprano=OFF
	)
	kde4-base_src_configure
}
