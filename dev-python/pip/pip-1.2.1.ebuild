# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pip/pip-1.2.1.ebuild,v 1.3 2012/10/30 17:03:46 ago Exp $

EAPI="4"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit bash-completion-r1 distutils eutils

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="http://www.pip-installer.org/ http://pypi.python.org/pypi/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="zsh-completion"

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}"

# Tests require a couple libraries not yet in the tree, aren't bundled with
# the default tarball from pypi, and have a couple failures anyway
RESTRICT="test"

DOCS="AUTHORS.txt docs/*.txt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.1-unversioned.patch
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	COMPLETION="${T}/completion.tmp"

	"$(PYTHON -f)" pip/runner.py completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}

	if use zsh-completion ; then
		"$(PYTHON -f)" pip/runner.py completion --zsh > "${COMPLETION}" || die
		insinto /usr/share/zsh/site-functions
		newins "${COMPLETION}" _pip
	fi
}
