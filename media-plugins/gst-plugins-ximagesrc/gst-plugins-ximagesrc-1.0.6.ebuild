# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ximagesrc/gst-plugins-ximagesrc-1.0.6.ebuild,v 1.1 2013/04/01 13:04:39 eva Exp $

EAPI="5"

inherit gst-plugins-good

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
"
DEPEND="${RDEPEND}
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/xextproto
	x11-proto/xproto
"

# xshm is a compile time option of ximage
GST_PLUGINS_BUILD="x xshm"
GST_PLUGINS_BUILD_DIR="ximage"
