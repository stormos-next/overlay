# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-4.10.1.ebuild,v 1.5 2013/04/02 20:51:13 ago Exp $

EAPI=5
KDE_HANDBOOK="optional"
KMNAME="kate"
PYTHON_COMPAT=( python{2_7,3_1,3_2} )

inherit python-single-r1 kde4-meta

DESCRIPTION="Kate is an MDI texteditor."
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma python"

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	python? ( $(add_kdebase_dep pykde4 "${PYTHON_USEDEP}" 4.9.2-r1) )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep katepart)
"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	kde4-meta_pkg_setup
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build python pate)
		$(cmake-utils_use_with plasma)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kaddressbook:${SLOT}; then
		echo
		elog "File templates plugin requires kde-base/kaddressbook:${SLOT}."
		elog "Please install it if you plan to use this plugin."
		echo
	fi
}
