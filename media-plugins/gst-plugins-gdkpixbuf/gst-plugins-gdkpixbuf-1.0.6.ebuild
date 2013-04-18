# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gdkpixbuf/gst-plugins-gdkpixbuf-1.0.6.ebuild,v 1.1 2013/04/01 12:56:51 eva Exp $

EAPI="5"

inherit gst-plugins-good

DESCRIPION="GdkPixbuf-based image decoder, overlay and sink"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gdk-pixbuf-2.8:2"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gdk_pixbuf"
GST_PLUGINS_BUILD_DIR="gdk_pixbuf"
