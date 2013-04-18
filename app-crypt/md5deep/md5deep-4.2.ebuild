# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/md5deep/md5deep-4.2.ebuild,v 1.3 2012/10/05 18:05:05 tristan Exp $

EAPI=4
inherit eutils

DESCRIPTION="Expanded md5sum program with recursive and comparison options"
HOMEPAGE="http://md5deep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="public-domain GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
RESTRICT="test"

DOCS="AUTHORS ChangeLog FILEFORMAT NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${P}-strict-aliasing.patch
}
