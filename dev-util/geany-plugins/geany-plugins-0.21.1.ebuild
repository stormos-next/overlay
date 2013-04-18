# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/geany-plugins/geany-plugins-0.21.1.ebuild,v 1.5 2012/06/14 17:55:10 xmw Exp $

EAPI=4

inherit autotools-utils versionator

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="http://plugins.geany.org/geany-plugins"
SRC_URI="http://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debugger devhelp enchant gpg gtkspell lua nls soup webkit"

LINGUAS="be ca da de es fr gl ja pt pt_BR ru tr zh_CN"

RDEPEND=">=dev-util/geany-$(get_version_component_range 1-2)
	dev-libs/libxml2:2
	dev-libs/glib:2
	debugger? ( x11-libs/vte:0 )
	devhelp? (
		dev-util/devhelp
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
		)
	enchant? ( app-text/enchant )
	gpg? ( app-crypt/gpgme )
	gtkspell? ( app-text/gtkspell:2 )
	lua? ( dev-lang/lua )
	soup? ( net-libs/libsoup )
	webkit? (
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
		x11-libs/gdk-pixbuf:2
		)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_configure() {
	# GeanyGenDoc requires ctpl which isn't yet in portage
	local myeconfargs=(
		--docdir=/usr/share/doc/${PF}
		--disable-cppcheck
		--disable-extra-c-warnings
		--disable-geanygendoc
		--enable-geanymacro
		--enable-geanynumberedbookmarks
		--enable-gproject
		--enable-tableconvert
		--enable-xmlsnippets
		$(use_enable enchant spellcheck)
		$(use_enable gpg geanypg)
		$(use_enable gtkspell)
		$(use_enable lua geanylua)
		$(use_enable nls)
		$(use_enable soup updatechecker)
		$(use_enable webkit webhelper)
	)

	autotools-utils_src_configure
}
