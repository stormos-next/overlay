# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-4.10.2.ebuild,v 1.1 2013/04/06 00:04:59 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdenetwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug telepathy"

DEPEND="
	sys-libs/zlib
	virtual/jpeg
	!aqua? (
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXtst
	)
	telepathy? ( >=net-libs/telepathy-qt-0.9 )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with telepathy TelepathyQt4)
	)

	kde4-meta_src_configure
}
