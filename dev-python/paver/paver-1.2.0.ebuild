# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paver/paver-1.2.0.ebuild,v 1.2 2013/03/27 12:04:33 pinkbyte Exp $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_2,3_3} pypy{1_9,2_0} )

inherit distutils-r1

MY_PN=${PN/p/P}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python-based software project scripting tool along the lines of Make"
HOMEPAGE="http://www.blueskyonmars.com/projects/paver/ http://pypi.python.org/pypi/Paver"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

DOCS="README.rst"
PATCHES=( "${FILESDIR}/${P}-skip-cog-tests.patch" )

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
