# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/print-manager/print-manager-4.10.1.ebuild,v 1.7 2013/04/06 18:02:01 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Manage print jobs and printers in KDE"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=net-print/cups-1.5.0[dbus]
"
RDEPEND="${DEPEND}
	!kde-misc/print-manager
"

add_blocker printer-applet
add_blocker system-config-printer-kde
