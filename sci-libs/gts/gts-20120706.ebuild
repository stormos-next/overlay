# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gts/gts-20120706.ebuild,v 1.3 2012/12/17 20:35:43 ago Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils fortran-2

MYP=${P/-20/-snapshot-}

DESCRIPTION="GNU Triangulated Surface Library"
LICENSE="LGPL-2"
HOMEPAGE="http://gts.sourceforge.net/"
SRC_URI="http://gts.sourceforge.net/tarballs/${MYP}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( media-libs/netpbm )"

S="${WORKDIR}/${MYP}"

PATCHES=( "${FILESDIR}"/${PN}-20111025-autotools.patch )

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile -C doc html
	chmod +x test/*/*.sh
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}"/doc/html/)
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi
}
