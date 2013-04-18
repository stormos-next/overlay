# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amr/gst-plugins-amr-1.0.5.ebuild,v 1.3 2013/02/21 16:45:17 ago Exp $

EAPI="5"

inherit gst-plugins-ugly

DESCRIPTION="GStreamer plugin for AMRNB/AMRWB codec"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/opencore-amr"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="amrnb amrwb"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
