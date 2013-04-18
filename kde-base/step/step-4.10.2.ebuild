# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/step/step-4.10.2.ebuild,v 1.1 2013/04/06 00:04:06 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="The KDE physics simulator"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +gsl +qalculate"

DEPEND="
	>=dev-cpp/eigen-2.0.3:2
	sci-libs/cln
	>=sci-mathematics/gmm-3.0
	gsl? ( >=sci-libs/gsl-1.9-r1 )
	qalculate? ( >=sci-libs/libqalculate-0.9.5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with gsl)
		$(cmake-utils_use_with qalculate)
	)
	kde4-base_src_configure
}
