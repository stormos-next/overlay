# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstars/kstars-4.10.2.ebuild,v 1.1 2013/04/06 00:04:41 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit flag-o-matic kde4-base

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug fits indi"

DEPEND="
	dev-cpp/eigen:2
	$(add_kdebase_dep libkdeedu)
	fits? ( >=sci-libs/cfitsio-0.390 )
	indi? ( >=sci-libs/indilib-0.9.1 )
"
RDEPEND="${DEPEND}"

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	mycmakeargs=(
		$(cmake-utils_use_with fits CFitsio)
		$(cmake-utils_use_with indi)
	)

	kde4-base_src_configure
}
