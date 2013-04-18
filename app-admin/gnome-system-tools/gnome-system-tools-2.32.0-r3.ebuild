# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gnome-system-tools/gnome-system-tools-2.32.0-r3.ebuild,v 1.7 2012/10/17 10:34:08 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="nfs policykit samba"

RDEPEND="
	>=app-admin/system-tools-backends-2.10.1
	>=dev-libs/liboobs-2.31.91
	>=x11-libs/gtk+-2.19.7:2
	>=dev-libs/glib-2.25.3:2
	dev-libs/dbus-glib
	>=gnome-base/nautilus-2.9.90
	sys-libs/cracklib
	nfs? ( net-fs/nfs-utils )
	samba? ( >=net-fs/samba-3 )
	policykit? (
		>=sys-auth/polkit-0.92
		|| ( gnome-extra/polkit-gnome:obsolete <gnome-extra/polkit-gnome-0.102 )
		)"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0"

pkg_setup() {
	DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

	G2CONF="${G2CONF}
		--disable-static
		$(use_enable policykit polkit-gtk)"

	if ! use nfs && ! use samba; then
		G2CONF="${G2CONF} --disable-shares"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libtool-intermediate-libs.patch \
		"${FILESDIR}"/${P}-missing-atk.patch \
		"${FILESDIR}"/${P}-missing-m.patch \
		"${FILESDIR}"/${P}-glib-2.32.patch
	eautoreconf
	gnome2_src_prepare
}
