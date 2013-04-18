# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django/django-1.4.2.ebuild,v 1.1 2012/11/16 15:16:30 idella4 Exp $

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_TESTS_RESTRICTED_ABIS="2.6"     		# fails with 1 single Error

inherit bash-completion-r1 distutils versionator webapp

MY_P="Django-${PV}"

DESCRIPTION="High-level Python web framework"
HOMEPAGE="http://www.djangoproject.com/ http://pypi.python.org/pypi/Django"
SRC_URI="https://www.djangoproject.com/m/releases/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc mysql postgres sqlite test"

RDEPEND="dev-python/imaging
	sqlite? ( || ( dev-lang/python:2.7[sqlite] dev-lang/python:2.6[sqlite] dev-lang/python:2.5[sqlite] dev-python/pysqlite:2 ) )
	postgres? ( dev-python/psycopg:2 )
	mysql? ( >=dev-python/mysql-python-1.2.3 )"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.0.7 )
	test? ( || ( dev-lang/python:2.7[sqlite] dev-lang/python:2.6[sqlite] dev-lang/python:2.5[sqlite] dev-python/pysqlite:2 ) )"

S="${WORKDIR}/${MY_P}"

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	python_pkg_setup
	webapp_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	# Disable tests requiring network connection.
	sed \
		-e "s/test_correct_url_value_passes/_&/" \
		-e "s/test_correct_url_with_redirect/_&/" \
		-i tests/modeltests/validation/tests.py || die
	sed \
		-e "s/test_urlfield_3/_&/" \
		-e "s/test_urlfield_4/_&/" \
		-e "s/test_urlfield_10/_&/" \
		-i tests/regressiontests/forms/tests/fields.py || die
}

src_compile() {
	distutils_src_compile
	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		# Tests have non-standard assumptions about PYTHONPATH and
		# don't work with usual "build-${PYTHON_ABI}/lib".
		PYTHONPATH="." "$(PYTHON)" tests/runtests.py --settings=test_sqlite -v1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	newbashcomp extras/django_bash_completion ${PN}

	if use doc; then
		rm -fr docs/_build/html/_sources
		dohtml -A txt -r docs/_build/html/*
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r django/contrib/admin/static/admin/*

	webapp_src_install
}

pkg_preinst() {
	:
}

pkg_postinst() {
	distutils_pkg_postinst

	einfo "Now, Django has the best of both worlds with Gentoo,"
	einfo "ease of deployment for production and development."
	echo
	elog "A copy of the admin media is available to"
	elog "webapp-config for installation in a webroot,"
	elog "as well as the traditional location in python's"
	elog "site-packages dir for easy development"
	echo
	ewarn "If you build Django ${PV} without USE=\"vhosts\""
	ewarn "webapp-config will automatically install the"
	ewarn "admin media into the localhost webroot."
}
