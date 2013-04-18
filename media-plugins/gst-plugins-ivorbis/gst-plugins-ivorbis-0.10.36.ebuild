# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ivorbis/gst-plugins-ivorbis-0.10.36.ebuild,v 1.3 2013/01/30 00:05:01 aballier Exp $

EAPI="5"

inherit gst-plugins-base gst-plugins10

KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

RDEPEND="media-libs/tremor"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD_DIR="vorbis"

src_prepare() {
	epatch "${FILESDIR}"/0.10.36-header-shuffle.patch

	gst-plugins10_system_link \
		gst-libs/gst/audio:gstreamer-audio \
		gst-libs/gst/tag:gstreamer-tag
}
