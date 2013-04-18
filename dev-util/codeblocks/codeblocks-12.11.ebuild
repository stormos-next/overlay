# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/codeblocks/codeblocks-12.11.ebuild,v 1.2 2013/04/13 05:37:04 dirtyepic Exp $

EAPI="5"
WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="The open source, cross platform, free C++ IDE."
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
SRC_URI="mirror://berlios/codeblocks/${P/-/_}-1.tar.gz"

IUSE="contrib debug pch static-libs"

RDEPEND="app-arch/zip
	x11-libs/wxGTK:2.8[X]
	contrib? (
		app-text/hunspell
		dev-libs/boost:=
		dev-libs/libgamin
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P}release8629"

src_configure() {
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		$(use_with contrib contrib-plugins all)
}

src_install() {
	default
	prune_libtool_files
}
