# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-xlib/python-xlib-0.15_rc1-r2.ebuild,v 1.1 2013/02/24 20:24:33 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} pypy{1_9,2_0} )

inherit distutils-r1

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="http://python-xlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc"

python_prepare_all() {
	sed -e 's:make:$(MAKE):g' -i doc/Makefile || die
	cp -r "${FILESDIR}"/defs doc/src/ || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		cd doc || die
		VARTEXFONTS="${T}"/fonts emake html
	fi
}

python_test() {
	cd test || die

	local t
	for t in *.py; do
		"${PYTHON}" "${t}" || die
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
