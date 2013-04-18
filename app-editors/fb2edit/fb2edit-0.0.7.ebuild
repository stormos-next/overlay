# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/fb2edit/fb2edit-0.0.7.ebuild,v 1.4 2013/03/23 10:30:10 pinkbyte Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="a WYSIWYG FictionBook (fb2) editor"
HOMEPAGE="http://fb2edit.lintest.ru/"
SRC_URI="http://lintest.ru/pub/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme"

DOCS=( AUTHORS README )

src_prepare() {
	# drop -g from CFLAGS
	sed -i -e '/^add_definitions(-W/s/-g//' CMakeLists.txt || die 'sed failed'

	cmake-utils_src_prepare
}
