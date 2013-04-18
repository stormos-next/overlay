# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gupnp-av/gupnp-av-0.12.1.ebuild,v 1.2 2013/03/31 16:46:06 eva Exp $

EAPI="5"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome.org vala

DESCRIPTION="A small utility library that aims to ease the handling UPnP A/V profiles"
HOMEPAGE="http://gupnp.org/"

LICENSE="LGPL-2"
SLOT="0/2" # subslot: soname version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=net-libs/gssdp-0.9.2[introspection?]
	>=net-libs/libsoup-2.28.2:2.4[introspection?]
	dev-libs/libxml2
	>=net-libs/gupnp-0.19[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	!net-libs/gupnp-vala
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	econf \
		$(use_enable introspection) \
		--disable-static \
		--disable-gtk-doc
}

src_install() {
	default
	prune_libtool_files
}
