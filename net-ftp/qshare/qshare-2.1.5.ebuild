# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/qshare/qshare-2.1.5.ebuild,v 1.4 2013/03/02 22:51:15 hwoarang Exp $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="FTP server with a service discovery feature"
HOMEPAGE="http://www.zuzuf.net/qshare/"
SRC_URI="http://www.zuzuf.net/qshare/files/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="net-dns/avahi[mdnsresponder-compat]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )
