# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rkward/rkward-0.5.7.ebuild,v 1.3 2013/04/11 21:44:14 ago Exp $

EAPI=4

KDE_DOC_DIRS="doc"
KDE_HANDBOOK="optional"
KDE_LINGUAS="ca cs da de el es fr it lt pl tr zh_CN"
inherit kde4-base

DESCRIPTION="An IDE/GUI for the R-project"
HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="mirror://sourceforge/rkward/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	dev-lang/R
	|| (	<kde-base/kdelibs-4.6.50
		( $(add_kdebase_dep katepart) ) )
"
RDEPEND="${DEPEND}"

src_install() {
	kde4-base_src_install
	# avoid file collisions
	rm -f "${ED}"/usr/$(get_libdir)/R/library/R.css
	rm -f "${ED}"/usr/share/apps/katepart/syntax/r.xml
}
