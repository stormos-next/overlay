# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gentoo/gentoo-0.19.13.ebuild,v 1.6 2012/06/17 17:36:00 armin76 Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A modern GTK+ based filemanager for any WM"
HOMEPAGE="http://www.obsession.se/gentoo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.24:2
	>=dev-libs/glib-2
	x11-libs/gdk-pixbuf
	x11-libs/pango"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

DOCS=(
	AUTHORS BUGS CONFIG-CHANGES CREDITS NEWS README TODO docs/{FAQ,menus.txt}
)

src_prepare() {
	sed -i \
		-e 's^icons/gnome/16x16/mimetypes^gentoo/icons^' \
		gentoorc.in || die
	sed -i \
		-e '/GTK_DISABLE_DEPRECATED/ d' \
		-e '/^GENTOO_CFLAGS=/s|".*"|"${CFLAGS}"|g' \
		configure.in || die #357343
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/gentoo \
		$(use_enable nls)
}

src_install() {
	default

	dohtml -r docs/{images,config,*.{html,css}}
	newman docs/gentoo.1x gentoo.1
	docinto scratch
	dodoc docs/scratch/*

	make_desktop_entry ${PN} Gentoo \
		/usr/share/${PN}/icons/${PN}.png \
		"System;FileTools;FileManager"
}
