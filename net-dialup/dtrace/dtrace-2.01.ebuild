# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/dtrace/dtrace-2.01.ebuild,v 1.2 2005/12/27 18:27:00 sbriesen Exp $

inherit eutils

DESCRIPTION="DTRACE traces ISDN messages with AVM ISDN-controllers"
HOMEPAGE="ftp://ftp.avm.de/develper/d3trace/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -*"
IUSE=""

RDEPEND="net-dialup/capi4k-utils"

S="${WORKDIR}/develper/d3trace/linux"

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix readme.txt
}

src_install() {
	newbin dtrace.static dtrace
	newdoc readme.txt README
}
