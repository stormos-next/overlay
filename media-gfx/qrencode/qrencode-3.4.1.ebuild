# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qrencode/qrencode-3.4.1.ebuild,v 1.2 2013/02/23 17:25:45 ago Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="http://fukuchi.org/works/qrencode/"
SRC_URI="http://fukuchi.org/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-3.2.0-pngregenfix.patch" )
