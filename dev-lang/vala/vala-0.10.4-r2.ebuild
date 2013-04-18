# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/vala/vala-0.10.4-r2.ebuild,v 1.12 2013/03/26 14:01:12 jer Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0.10"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE="test +vapigen"

RDEPEND=">=dev-libs/glib-2.14:2
	>=dev-libs/vala-common-${PV}"
DEPEND="${RDEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		>=dev-libs/glib-2.26:2
		dev-libs/dbus-glib )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-unversioned
		$(use_enable vapigen)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_install() {
	gnome2_src_install
	rm -v "${ED}usr/share/aclocal/vala.m4" || die "rm failed"
	rmdir "${ED}usr/share/aclocal" || die "rmdir failed"
}
