# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/glabels/glabels-3.0.1.ebuild,v 1.4 2013/04/01 18:23:25 ago Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Program for creating labels and business cards"
HOMEPAGE="http://www.glabels.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="barcode doc eds"

RDEPEND=">=dev-libs/glib-2.28.2:2
	>=x11-libs/gtk+-3.0.9:3
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/librsvg-2.32.0:2
	>=x11-libs/cairo-1.10.0
	>=x11-libs/pango-1.28.1
	barcode? (
		>=app-text/barcode-0.98
		>=media-gfx/qrencode-3.1 )
	eds? ( >=gnome-extra/evolution-data-server-2.30.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.28
	doc? ( dev-util/gtk-doc )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		$(use_with eds libebook)
		--disable-static"
}

src_prepare() {
	# Fix desktop entry, upstream bug #684612
	sed -i -e 's/.png//' data/desktop/glabels-3.0.desktop.in || die
	sed -i -e '/Encoding/d' data/desktop/glabels-3.0.desktop.in || die
}
