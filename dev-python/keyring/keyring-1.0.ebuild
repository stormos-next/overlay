# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keyring/keyring-1.0.ebuild,v 1.5 2013/01/07 00:03:34 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy{1_9,2_0} )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://bitbucket.org/kang/python-keyring-lib"
SRC_URI="mirror://pypi/k/${PN}/${P}.zip"

LICENSE="PSF-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( virtual/python-unittest2[${PYTHON_USEDEP}] )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/setup-1.0.patch"
)

python_test() {
	# test_backend.py and test_core.py access keyring backends
	# which may spawn password prompts and do other damage.

	# XXX: leave out the harmless tests (dummy backends?)

	for t in test_{cli,util}.py; do
		"${PYTHON}" "${BUILD_DIR}"/lib/${PN}/tests/${t} \
			|| die "${t} fails with ${EPYTHON}"
	done
}
