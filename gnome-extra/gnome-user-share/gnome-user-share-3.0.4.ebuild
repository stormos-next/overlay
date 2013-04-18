# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-user-share/gnome-user-share-3.0.4.ebuild,v 1.1 2012/10/28 16:17:29 eva Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# FIXME: could libnotify be made optional ?
# FIXME selinux automagic support
RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3:3
	>=app-mobilephone/obex-data-server-0.4
	>=dev-libs/dbus-glib-0.70
	>=gnome-base/nautilus-2.91.7
	media-libs/libcanberra[gtk3]
	>=net-wireless/gnome-bluetooth-2.91.5:2
	>=net-wireless/bluez-4.18
	>=sys-apps/dbus-1.1.1
	>=www-apache/mod_dnssd-0.6
	=www-servers/apache-2.2*[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	>=x11-libs/libnotify-0.7
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		ITSTOOL=$(type -P true)
		--disable-schemas-compile
		--with-httpd=apache2
		--with-modules-path=/usr/$(get_libdir)/apache2/modules/"

	# Rebuild marshalers for <glib-2.31 compatibility
	rm -v src/marshal.{c,h} || die
	gnome2_src_prepare
}
