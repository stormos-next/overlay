# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gnome-bluetooth/gnome-bluetooth-3.8.0.ebuild,v 1.1 2013/03/28 22:16:44 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome2 multilib udev user

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2/11" # subslot = libgnome-bluetooth soname version
IUSE="+introspection"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	>=x11-libs/gtk+-2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7:=
	virtual/udev

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
"
# eautoreconf needs:
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

pkg_setup() {
	enewgroup plugdev
}

src_prepare() {
	# Regenerate gdbus-codegen files to allow using any glib version; bug #436236
	rm -v lib/bluetooth-client-glue.{c,h} || die
	gnome2_src_prepare
}

src_configure() {
	# FIXME: Add geoclue support
	G2CONF="${G2CONF}
		$(use_enable introspection)
		--enable-documentation
		--disable-maintainer-mode
		--disable-desktop-update
		--disable-icon-update
		--disable-static
		ITSTOOL=$(type -P true)"
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
	udev_dorules "${FILESDIR}"/61-${PN}.rules
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! has_version sys-auth/consolekit[acl] ; then
		elog "Don't forget to add yourself to the plugdev group "
		elog "if you want to be able to control bluetooth transmitter."
	fi
}
