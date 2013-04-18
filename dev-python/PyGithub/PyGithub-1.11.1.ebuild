# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyGithub/PyGithub-1.11.1.ebuild,v 1.1 2013/02/10 05:31:47 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2} )
# TODO(floppym): Investigate test failures with python-3.3

inherit distutils-r1

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="http://vincent-jacques.net/PyGithub"
# Use github since pypi is missing test data
SRC_URI="https://github.com/jacquev6/PyGithub/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
