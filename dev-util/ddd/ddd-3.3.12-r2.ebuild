# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ddd/ddd-3.3.12-r2.ebuild,v 1.9 2012/10/24 19:09:45 ulm Exp $

EAPI="4"

inherit autotools-utils eutils

DESCRIPTION="Graphical front-end for command-line debuggers"
HOMEPAGE="http://www.gnu.org/software/ddd"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 FDL-1.1"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="+gnuplot"

COMMON_DEPEND="
	sys-devel/gdb
	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	>=x11-libs/motif-2.3:0
	ppc? ( dev-libs/elfutils )
	ppc64? ( dev-libs/elfutils )
"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xfontsel
	gnuplot? ( sci-visualization/gnuplot )
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-gcc44.patch"
)

DOCS=(
	AUTHORS CREDITS INSTALL NEWS PROBLEMS README TIPS TODO
	doc/ddd{-paper.ps,.pdf,-themes.pdf}
)

src_install() {
	# Remove app defaults
	rm -f "${S}"/ddd/Ddd

	# Install ddd distribution
	autotools-utils_src_install

	# Install application icon
	doicon "${S}"/icons/ddd.xpm
}

pkg_postinst() {
	if ! use gnuplot; then
		echo
		elog "To enable data visualization in DDD, install sci-visualization/gnuplot,"
		elog "or re-emerge DDD with gnuplot USE flag (recommended)."
		elog "For flat file package.use layout:"
		elog "   echo '${CATEGORY}/${PN} gnuplot' >> /etc/portage/package.use && emerge -va gnuplot"
		elog "For directory package.use layout:"
		elog "   echo '${CATEGORY}/${PN} gnuplot' > /etc/portage/package.use/ddd && emerge -va gnuplot"
	fi
	echo
	elog "To be able to debug java, bash, perl or python scripts within DDD, install respectively:"
	elog "    virtual/jdk"
	elog "    app-shells/bashdb"
	elog "    dev-lang/perl"
	elog "    dev-python/pydb"
	echo
}
