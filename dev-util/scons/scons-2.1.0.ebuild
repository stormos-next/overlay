# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/scons/scons-2.1.0.ebuild,v 1.13 2012/08/06 03:39:23 patrick Exp $

EAPI="4"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="threads(+)"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"
PYTHON_MODNAME="SCons"

inherit distutils eutils

DESCRIPTION="Extensible Python-based build utility"
HOMEPAGE="http://www.scons.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( http://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf -> ${P}-user.pdf
	       http://www.scons.org/doc/${PV}/HTML/${PN}-user.html -> ${P}-user.html )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

DEPEND=""
RDEPEND=""

DOCS="CHANGES.txt RELEASE.txt"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/scons-1.2.0-popen.patch"
	epatch "${FILESDIR}/${P}-jython.patch"

	# https://bugs.gentoo.org/show_bug.cgi?id=361061
	sed -i -e "s|/usr/local/bin:/opt/bin:/bin:/usr/bin|${EPREFIX}usr/local/bin:${EPREFIX}opt/bin:${EPREFIX}bin:${EPREFIX}usr/bin:/usr/local/bin:/opt/bin:/bin:/usr/bin|g" engine/SCons/Platform/posix.py || die
	# and make sure the build system doesn't "force" /usr/local/ :(
	sed -i -e "s/'darwin'/'NOWAYdarwinWAYNO'/" setup.py || die
}

src_install () {
	distutils_src_install \
		--standard-lib \
		--no-version-script \
		--install-data "${EPREFIX}"/usr/share

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${P}-user.{pdf,html}
	fi
}
