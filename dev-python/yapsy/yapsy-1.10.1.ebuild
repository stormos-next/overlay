# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/yapsy/yapsy-1.10.1.ebuild,v 1.3 2013/04/17 08:22:41 ago Exp $

EAPI="5"

MY_P="Yapsy-${PV}-pythons2n3"
PYTHON_COMPAT=( python{2_7,3_2} )

inherit distutils-r1

DESCRIPTION="A fat-free DIY Python plugin management toolkit"
HOMEPAGE="http://yapsy.sourceforge.net/"
SRC_URI="mirror://sourceforge/yapsy/Yapsy-${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}
