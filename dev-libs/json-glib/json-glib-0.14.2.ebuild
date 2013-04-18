# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/json-glib/json-glib-0.14.2.ebuild,v 1.11 2013/03/03 08:38:15 vapier Exp $

EAPI=4
GCONF_DEBUG=yes
GNOME2_LA_PUNT=yes

inherit gnome2

DESCRIPTION="A library providing GLib serialization and deserialization support for the JSON format"
HOMEPAGE="http://live.gnome.org/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="+introspection"

RDEPEND=">=dev-libs/glib-2.26:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=sys-devel/gettext-0.18
	virtual/pkgconfig"

src_configure() {
	DOCS="ChangeLog NEWS README"
	# Coverage support is useless, and causes runtime problems
	G2CONF="${G2CONF}
		--disable-gcov
		$(use_enable introspection)"
	gnome2_src_configure
}
