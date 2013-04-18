# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kig/kig-4.10.1.ebuild,v 1.5 2013/04/02 20:51:26 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug scripting"

DEPEND="
	scripting? ( >=dev-libs/boost-1.48:=[python] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.10.0-boostpython.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with scripting)
	)

	kde4-base_src_configure
}
