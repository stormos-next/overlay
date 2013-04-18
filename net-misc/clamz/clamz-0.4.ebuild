# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/clamz/clamz-0.4.ebuild,v 1.4 2012/05/05 03:20:44 jdhore Exp $

EAPI=3
inherit fdo-mime

DESCRIPTION="Command-line downloader for the Amazon.com MP3 music store"
HOMEPAGE="http://code.google.com/p/clamz/"
SRC_URI="http://clamz.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/expat
	net-misc/curl
	dev-libs/libgcrypt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	UPDATE_MIME_DATABASE=true \
	UPDATE_DESKTOP_DATABASE=true \
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	einfo "To link clamz with your amazon.com account, visit:"
	einfo "  http://www.amazon.com/gp/dmusic/after_download_manager_install.html"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
