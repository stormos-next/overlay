# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3splt-gtk/mp3splt-gtk-0.7.0.930.ebuild,v 1.2 2012/05/21 19:10:52 xarthisius Exp $

EAPI=2
inherit versionator autotools eutils multilib

DESCRIPTION="a GTK+ based utility to split mp3 and ogg files without decoding."
HOMEPAGE="http://mp3splt.sourceforge.net"
SRC_URI="http://ioalex.net/testing_downloads/snapshots/$(get_version_component_range 4)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="audacious doc gtk3 gnome gstreamer nls"

RDEPEND=">=media-libs/libmp3splt-0.7.0.920
	gtk3? ( x11-libs/gtk+:3
		audacious? ( >=media-sound/audacious-3.0 ) )
	!gtk3? ( >=x11-libs/gtk+-2.6:2
		audacious? ( <media-sound/audacious-3.0 ) )
	gstreamer? ( media-libs/gst-plugins-base:0.10 )
	gnome? ( gnome-base/libgnomeui )"
DEPEND="${RDEPEND}
	gnome? ( app-text/gnome-doc-utils app-text/rarian )
	nls? ( sys-devel/gettext )"

src_prepare() {
	if use audacious; then
		sed -i \
			-e 's:@AUDACIOUS_LIBS@:-laudclient &:' \
			src/Makefile.am || die
	fi

	epatch "${FILESDIR}"/${P}-gtk.patch
	eautoreconf
}

src_configure() {
	local myconf

	use nls || myconf+=" --disable-nls"
	use audacious || myconf+=" --disable-audacious"
	use gstreamer || myconf+=" --disable-gstreamer"

	econf \
		--disable-dependency-tracking \
		--with-mp3splt-libraries=/usr/$(get_libdir) \
		--with-mp3splt-includes=/usr/include/libmp3splt \
		$(use_enable gnome) \
		$(use_enable doc doxygen_doc) \
		$(use_enable gtk3) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
