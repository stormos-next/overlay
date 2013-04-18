# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalzium/kalzium-4.10.2.ebuild,v 1.1 2013/04/06 00:04:26 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-base flag-o-matic

DESCRIPTION="KDE: periodic table of the elements."
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="editor debug +plasma solver"

DEPEND="
	$(add_kdebase_dep libkdeedu)
	editor? (
		>=dev-cpp/eigen-2.0.3:2
		sci-chemistry/avogadro
		>=sci-chemistry/openbabel-2.2
	)
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND=${DEPEND}

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
	libkdeedu/libscience/
"

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	mycmakeargs=(
		$(cmake-utils_use_with editor Eigen2)
		$(cmake-utils_use_with editor Avogadro)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with editor OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)
	)

	kde4-base_src_configure
}
