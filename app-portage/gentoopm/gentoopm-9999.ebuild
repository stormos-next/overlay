# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoopm/gentoopm-9999.ebuild,v 1.3 2013/01/09 21:38:33 zerochaos Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} pypy{1_8,1_9} )

inherit distutils-r1

#if LIVE
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/${PN}.git
	http://git.overlays.gentoo.org/gitroot/proj/${PN}.git
	http://bitbucket.org/mgorny/${PN}.git"
inherit git-2
#endif

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

#if LIVE
KEYWORDS=
SRC_URI=
#endif

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
