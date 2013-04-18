# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/atpy/atpy-0.9.6.ebuild,v 1.2 2013/01/15 23:15:17 mgorny Exp $

EAPI="2"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] 3.* *-jython"

PYTHON_USE_WITH=sqlite
PYTHON_USE_WITH_OPT=sqlite

inherit distutils

MYPN=ATpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical tables support for Python"
HOMEPAGE="http://atpy.github.com/ http://pypi.python.org/pypi/ATpy"
SRC_URI="mirror://github/${PN}/${PN}/${MYP}.tar.gz"

RDEPEND="dev-python/numpy
	dev-python/asciitable
	fits? ( dev-python/pyfits )
	hdf5? ( dev-python/h5py )
	mysql? ( dev-python/mysql-python )
	postgres? ( dev-db/pygresql )
	votable? ( dev-python/vo )"

DEPEND=">=dev-python/numpy-1.3"

IUSE="+fits hdf5 mysql postgres sqlite +votable"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

S="${WORKDIR}/${MYP}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/unittests.py
	}
	python_execute_function testing
}
