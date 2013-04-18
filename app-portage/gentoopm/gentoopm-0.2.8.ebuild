# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoopm/gentoopm-0.2.8.ebuild,v 1.1 2013/02/16 11:58:45 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} pypy{1_8,1_9} )

inherit distutils-r1

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://bitbucket.org/mgorny/gentoopm/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

RDEPEND="|| (
		sys-apps/pkgcore
		>=sys-apps/portage-2.1.10.3
		>=sys-apps/paludis-0.64.2[python-bindings] )"
DEPEND="doc? ( dev-python/epydoc )"
PDEPEND="app-admin/eselect-package-manager"

python_compile_all() {
	if use doc; then
		python_export_best
		"${PYTHON}" setup.py doc || die
	fi
}

python_test() {
	"${PYTHON}" setup.py test || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/* )

	distutils-r1_python_install_all
}
