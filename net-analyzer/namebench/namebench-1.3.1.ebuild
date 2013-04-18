# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/namebench/namebench-1.3.1.ebuild,v 1.2 2012/02/10 03:16:07 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH_OPT="X"
PYTHON_USE_WITH="tk"

inherit distutils

DESCRIPTION="DNS Benchmark Utility"
HOMEPAGE="http://code.google.com/p/namebench/"
SRC_URI="http://namebench.googlecode.com/files/${P}-source.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-python/dnspython-1.8.0
	>=dev-python/httplib2-0.6
	>=dev-python/graphy-1.0
	>=dev-python/jinja-2.2.1
	>=dev-python/simplejson-2.1.2"

pkg_setup() {
	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs -r 2 .

	# don't include bundled libraries
	export NO_THIRD_PARTY=1
}

src_install() {
	distutils_src_install --install-data=/usr/share

	dosym ${PN}.py /usr/bin/${PN} || die
}
