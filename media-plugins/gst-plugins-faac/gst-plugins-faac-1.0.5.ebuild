# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-1.0.5.ebuild,v 1.6 2013/02/23 14:50:43 ago Exp $

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ~arm ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="media-libs/faac"
DEPEND="${RDEPEND}"
