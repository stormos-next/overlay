# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits/scikits-0.1-r1.ebuild,v 1.1 2013/02/06 15:43:16 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} pypy{1_9,2_0} )

inherit python-r1

DESCRIPTION="Common files for python scikits"
HOMEPAGE="http://projects.scipy.org/scipy/scikits"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}.example/${PN}.example-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

S="${WORKDIR}"

src_install() {
	python_moduleinto scikits
	python_foreach_impl python_domodule scikits.example*/scikits/__init__.py

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r scikits.example*/*
	fi
}
