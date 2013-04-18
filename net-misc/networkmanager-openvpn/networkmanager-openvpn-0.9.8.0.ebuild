# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-openvpn/networkmanager-openvpn-0.9.8.0.ebuild,v 1.1 2013/04/07 15:12:05 pacho Exp $

EAPI=5
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit eutils gnome2-utils gnome.org

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk test"

RDEPEND="
	>=dev-libs/dbus-glib-0.74
	>=net-misc/networkmanager-${PV}
	>=net-misc/openvpn-2.1_rc9
	gtk? (
		>=x11-libs/gtk+-2.91.4:3
		gnome-base/gnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

src_prepare() {
	# Test will fail if the machine doesn't have a particular locale installed
	# FAIL: (tls-import-data) unexpected 'ca' secret value
	sed '/test_non_utf8_import (plugin, test_dir)/ d' \
		-i properties/tests/test-import-export.c || die "sed failed"

	# Drop DEPRECATED flags, bug #385597
	gnome2_disable_deprecation_warning
}

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		--with-gtkver=3 \
		$(use_with gtk gnome) \
		$(use_with test tests)
}

src_install() {
	default
	prune_libtool_files
}
