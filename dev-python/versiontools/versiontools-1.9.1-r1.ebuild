# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/versiontools/versiontools-1.9.1-r1.ebuild,v 1.1 2013/03/21 14:47:10 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2} pypy{1_9,2_0} )
#DISTUTILS_SRC_TEST=setup.py

inherit distutils-r1

DESCRIPTION="Smart replacement for plain tuple used in __version__"
HOMEPAGE="http://pypi.python.org/pypi/versiontools/ https://launchpad.net/versiontools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE=""

LICENSE="GPL-2"
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
