# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tintii/tintii-2.6.1.ebuild,v 1.1 2012/03/17 22:36:57 radhermit Exp $

EAPI="4"
WX_GTK_VER="2.8"

inherit autotools wxwidgets

DESCRIPTION="A photo editor for selective color, saturation, and hue shift adjustments"
HOMEPAGE="http://www.indii.org/software/tintii"
SRC_URI="http://www.indii.org/files/tint/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_prepare() {
	sed -i -e 's/^\(AM_CXXFLAGS = $(DEPS_CXXFLAGS)\).*/\1/' Makefile.am
	eautoreconf
}
