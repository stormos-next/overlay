# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmime/gmime-2.6.13.ebuild,v 1.10 2013/04/01 18:23:56 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 eutils mono

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/ http://developer.gnome.org/gmime/stable/"

SLOT="2.6"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc mono static-libs"

RDEPEND=">=dev-libs/glib-2.18:2
	sys-libs/zlib
	>=app-crypt/gpgme-1.1.6
	mono? (
		dev-lang/mono
		>=dev-dotnet/glib-sharp-2.4.0:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	mono? ( dev-dotnet/gtk-sharp-gapi:2 )
"

src_configure() {
	G2CONF+="
		--enable-cryptography
		--disable-strict-parser
		$(use_enable mono)
		$(use_enable static-libs static)"
	gnome2_src_configure
}

src_compile() {
	MONO_PATH="${S}" gnome2_src_compile
	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	GACUTIL_FLAGS="/root '${ED}/usr/$(get_libdir)' /gacdir '${EPREFIX}/usr/$(get_libdir)' /package ${PN}" \
		gnome2_src_install

	if use doc ; then
		docinto tutorial
		dodoc docs/tutorial/html/*
	fi
}
