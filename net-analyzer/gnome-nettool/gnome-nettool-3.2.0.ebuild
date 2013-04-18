# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnome-nettool/gnome-nettool-3.2.0.ebuild,v 1.3 2012/05/04 06:08:10 jdhore Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="Collection of network tools"
HOMEPAGE="http://www.gnome.org/projects/gnome-network/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.25.10
	gnome-base/libgtop:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.90.4:3
	x11-libs/pango"
RDEPEND="${COMMON_DEPEND}
	|| (
		net-misc/iputils
		net-analyzer/tcptraceroute
		net-analyzer/traceroute
		sys-freebsd/freebsd-usbin )
	net-analyzer/nmap
	net-dns/bind-tools
	userland_GNU? ( net-misc/netkit-fingerd net-misc/whois )
	userland_BSD? ( net-misc/bsdwhois )"

# Gilles Dartiguelongue <eva@gentoo.org> (12 Apr 2008)
# Mask gnome-system-tools 2.14 because it is starting to cause more headache
# to keep it than to mask it.
# Support is autodetected at runtime anyway.
# app-admin/gnome-system-tools

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	app-text/gnome-doc-utils
	sys-devel/gettext"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		$(use_enable debug)
		--disable-schemas-compile
		--disable-scrollkeeper"
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=674126
	epatch "${FILESDIR}/${PN}-3.2.0-extra-path.patch"
	gnome2_src_prepare
}
