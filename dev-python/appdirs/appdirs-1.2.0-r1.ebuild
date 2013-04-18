# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/appdirs/appdirs-1.2.0-r1.ebuild,v 1.1 2013/01/20 00:16:10 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} pypy{1_9,2_0} )

inherit distutils-r1

DESCRIPTION="Module for determining appropriate platform-specific dirs"
HOMEPAGE="http://github.com/ActiveState/appdirs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# api.doctests is missing in the dist zipfile
# and the 'internal' doctest does nothing
RESTRICT=test

python_test() {
	cd test || die
	"${PYTHON}" test.py \
		|| die "Tests fail with ${EPYTHON}"
}
