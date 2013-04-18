# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/office-runner/office-runner-1.0.ebuild,v 1.2 2013/02/24 01:45:59 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Lighthearted tool to temporarily inhibit GNOME's suspend on lid close behavior"
HOMEPAGE="http://www.gnome.org/ http://www.hadess.net/search/label/office-runner"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/glib:2
	>=gnome-base/gnome-settings-daemon-3.0
	x11-libs/gtk+:3
"
# requires systemd's org.freedesktop.login1 dbus service
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/systemd-190
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	sys-devel/gettext
"

pkg_postinst() {
	gnome2_pkg_postinst

	elog "Note: ${PN} inhibits suspend on lid close only for 10 minutes"
}
