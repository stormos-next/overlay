# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylint/pylint-0.27.0.ebuild,v 1.1 2013/03/11 06:14:51 patrick Exp $

EAPI="4"
PYTHON_DEPEND="*:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="Python code static checker"
HOMEPAGE="http://www.logilab.org/project/pylint http://pypi.python.org/pypi/pylint"
SRC_URI="ftp://ftp.logilab.org/pub/${PN}/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="examples"

# Versions specified in __pkginfo__.py.
RDEPEND=">=dev-python/logilab-common-0.53.0
	>=dev-python/astng-0.21.1"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="doc/*.txt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.26.0-gtktest.patch
	distutils_src_prepare
}

src_test() {
	testing() {
		# Test suite broken with Python 3.
		[[ "${PYTHON_ABI}" == 3.* ]] && return

		PYTHONPATH="build/lib" pytest -v
	}
	python_execute_function -s testing
}

src_install() {
	distutils_src_install

	doman man/{pylint,pyreverse}.1 || die "doman failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "dodoc failed"
	fi

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/pylint/test"
	}
	python_execute_function -q delete_tests
}

pkg_postinst() {
	distutils_pkg_postinst

	# Optional dependency on "tk" USE flag would break support for Jython.
	elog "pylint-gui script requires dev-lang/python with \"tk\" USE flag enabled."
}
