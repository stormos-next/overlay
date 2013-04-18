# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cantarell/cantarell-0.0.12.ebuild,v 1.10 2013/04/09 16:43:58 ago Exp $

EAPI="5"
GNOME_ORG_MODULE="${PN}-fonts"

inherit font gnome.org

DESCRIPTION="Default fontset for GNOME Shell"
HOMEPAGE="https://live.gnome.org/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/fontconfig"
DEPEND="virtual/pkgconfig"

DOCS="NEWS README"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# Font eclass settings
FONT_CONF=("${S}/fontconfig/31-cantarell.conf")
FONT_S="${S}/otf"
FONT_SUFFIX="otf"
