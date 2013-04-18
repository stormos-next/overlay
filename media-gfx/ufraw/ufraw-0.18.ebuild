# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/ufraw/ufraw-0.18.ebuild,v 1.14 2013/03/03 11:14:16 vapier Exp $

EAPI=4
inherit autotools eutils fdo-mime gnome2-utils

DESCRIPTION="RAW Image format viewer and GIMP plugin"
HOMEPAGE="http://ufraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="contrast fits gimp gnome gtk openmp timezone"

RDEPEND="dev-libs/glib:2
	>=media-gfx/exiv2-0.11
	virtual/jpeg
	=media-libs/lcms-1*
	>=media-libs/lensfun-0.2.5
	media-libs/tiff
	fits? ( sci-libs/cfitsio )
	gnome? ( >=gnome-base/gconf-2 )
	gtk? ( >=x11-libs/gtk+-2.6:2
		>=media-gfx/gtkimageview-1.5 )
	gimp? ( >=x11-libs/gtk+-2.6:2
		>=media-gfx/gtkimageview-1.5
		>=media-gfx/gimp-2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.17-cfitsio-automagic.patch
	eautoreconf
}

src_configure() {
	local myconf
	use gimp && myconf="--with-gtk"

	econf \
		--disable-silent-rules \
		--without-cinepaint \
		$(use_enable contrast) \
		$(use_with fits cfitsio) \
		$(use_with gimp) \
		$(use_enable gnome mime) \
		$(use_with gtk) \
		$(use_enable openmp) \
		$(use_enable timezone dst-correction) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" schemasdir=/etc/gconf/schemas install
	dodoc README TODO
}

pkg_preinst() {
	if use gnome; then
		gnome2_gconf_savelist
	fi
}

pkg_postinst() {
	if use gnome; then
		fdo-mime_mime_database_update
		fdo-mime_desktop_database_update
		gnome2_gconf_install
	fi
}

pkg_postrm() {
	if use gnome; then
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
	fi
}
