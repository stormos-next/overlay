# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-schroedinger/gst-plugins-schroedinger-1.0.5.ebuild,v 1.3 2013/02/21 16:53:18 ago Exp $

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/schroedinger-1.0.10"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="schro"
GST_PLUGINS_BUILD_DIR="schroedinger"
