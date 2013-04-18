# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/semantik/semantik-0.8.3.ebuild,v 1.2 2013/03/02 21:30:54 hwoarang Exp $

EAPI=4

CMAKE_REQUIRED="never"
PYTHON_DEPEND="2"
inherit python kde4-base waf-utils

DESCRIPTION="Mindmapping-like tool for document generation."
HOMEPAGE="http://freehackers.org/~tnagy/semantik.html"
SRC_URI="https://semantik.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
"

RDEPEND="${DEPEND}
	dev-lang/python[xml]
"

WAF_BINARY="${S}/waf"

DOCS=( ChangeLog README TODO )
PATCHES=(
	"${FILESDIR}/${P}"-wscript_ldconfig.patch
)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	kde4-base_pkg_setup
}

src_configure() {
	CCFLAGS="${CFLAGS}" CPPFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS} -Wl,--soname=libnablah.so.0" \
		"${WAF_BINARY}" "--prefix=${EPREFIX}/usr" \
		configure || die "configure failed"
}

src_install() {
	waf-utils_src_install
	dosym libnablah.so /usr/lib64/libnablah.so.0
}
