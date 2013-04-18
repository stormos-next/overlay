# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ffmpeg/gst-plugins-ffmpeg-0.10.11-r1.ebuild,v 1.10 2012/12/02 16:12:06 eva Exp $

EAPI=1

inherit flag-o-matic eutils base

PD=${FILESDIR}/${PV}
MY_PN=${PN/-plugins}
MY_P=${MY_PN}-${PV}

# Create a major/minor combo for SLOT
PVP=(${PV//[-\._]/ })
SLOT=${PVP[0]}.${PVP[1]}
#SLOT=0.10

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-ffmpeg.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="+orc"

S=${WORKDIR}/${MY_P}

RDEPEND=">=media-libs/gstreamer-0.10.25:0.10
	>=media-libs/gst-plugins-base-0.10.25:0.10
	orc? ( >=dev-lang/orc-0.4.5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	append-flags -fno-strict-aliasing

	econf $(use_enable orc)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO
}
