# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinput/xinput-1.5.4.ebuild,v 1.2 2012/05/15 14:14:47 aballier Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="Utility to set XInput device parameters"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.3
	x11-libs/libXext
	>=x11-libs/libXi-1.4.5"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-2.0"
