# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasma-widget-menubar/plasma-widget-menubar-0.1.18.ebuild,v 1.2 2012/06/15 10:54:13 kensington Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="A Plasma widget to display menubar of application windows"
HOMEPAGE="https://launchpad.net/plasma-widget-menubar"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=dev-libs/libdbusmenu-qt-0.6.0
	>=dev-libs/qjson-0.7.1
"
RDEPEND="${DEPEND}
	!kde-misc/plasma-indicatordisplay
	x11-misc/appmenu-qt
"

# last checked 0.1.18
RESTRICT="test"
