# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mozprofile/mozprofile-0.4.ebuild,v 1.3 2013/01/17 16:22:30 mgorny Exp $

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_USE_WITH=sqlite

inherit distutils

DESCRIPTION="Handling of Mozilla XUL app profiles"
HOMEPAGE="http://github.com/mozautomation/mozmill http://pypi.python.org/pypi/mozprofile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-python/manifestdestiny
	dev-python/simplejson
	dev-python/setuptools"
RDEPEND="${DEPEND}"
