# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libzapojit/libzapojit-0.0.3.ebuild,v 1.2 2013/03/31 14:35:37 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GLib/GObject wrapper for the SkyDrive and Hotmail REST APIs"
HOMEPAGE="http://git.gnome.org/browse/libzapojit"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/libsoup-2.38:2.4
	dev-libs/json-glib
	net-libs/rest
	net-libs/gnome-online-accounts

	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#	gnome-base/gnome-common:3

src_configure() {
	gnome2_src_configure \
		--enable-compile-warnings=minimum \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install
	# Drop self-installed documentation
	rm -r "${ED}"/usr/share/doc/${PN}/ || die
}
