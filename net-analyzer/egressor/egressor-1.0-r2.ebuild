# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/egressor/egressor-1.0-r2.ebuild,v 1.3 2012/11/20 20:09:34 ago Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="tool for checking router configuration"
HOMEPAGE="http://packetfactory.openwall.net/projects/egressor/"
SRC_URI="${HOMEPAGE}${PN}_release${PV}.tar.gz"

LICENSE="egressor"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc x86"

DEPEND="<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3"
RDEPEND="net-libs/libpcap
	dev-perl/Net-RawIP
	dev-lang/perl"

S=${WORKDIR}

src_prepare() {
	epatch \
		${FILESDIR}/${PV}-libnet-1.0.patch \
		${FILESDIR}/${PV}-flags.patch
}

src_compile() {
	tc-export CC
	cd client
	emake || die
}

src_install() {
	dobin client/egressor server/egressor_server.pl
	dodoc README client/README-CLIENT server/README-SERVER
}
