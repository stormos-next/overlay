# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libosinfo/libosinfo-0.2.4.ebuild,v 1.2 2013/03/31 19:09:03 pacho Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit eutils toolchain-funcs vala udev

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="http://fedorahosted.org/libosinfo/"
SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+introspection +vala test"

REQUIRED_USE="vala? ( introspection )"

RDEPEND=">=dev-libs/glib-2:2
	>=dev-libs/libxslt-1.0.0:=
	dev-libs/libxml2:=
	|| ( >=net-libs/libsoup-2.42:2.4 net-libs/libsoup-gnome:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? ( dev-libs/check )
	vala? ( $(vala_depend) )"

src_configure() {
	# --enable-udev is only for rules.d file install
	econf \
		--disable-static \
		$(use_enable test tests) \
		$(use_enable introspection) \
		$(use_enable vala) \
		--enable-udev \
		--disable-coverage \
		--with-udev-rulesdir="$(udev_get_udevdir)"/rules.d \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	default
	prune_libtool_files
}
