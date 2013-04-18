# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/socat/socat-2.0.0_beta5.ebuild,v 1.3 2012/10/26 02:41:32 vapier Exp $

EAPI="4"

inherit eutils flag-o-matic autotools

DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/"
MY_P=${P/_beta/-b}
S="${WORKDIR}/${MY_P}"
SRC_URI="http://www.dest-unreach.org/socat/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="ssl readline ipv6 tcpd"

DEPEND="
	ssl? ( >=dev-libs/openssl-0.9.6 )
	readline? ( >=sys-libs/ncurses-5.1 >=sys-libs/readline-4.1 )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.2.0-cross-compile.patch
	epatch "${FILESDIR}"/${PN}-1.7.2.1-long-long.patch #436164
	eautoreconf
	touch doc/${PN}.1 || die
}

src_configure() {
	filter-flags -Wall '-Wno-error*' #293324
	econf \
		$(use_enable ssl openssl) \
		$(use_enable readline) \
		$(use_enable ipv6 ip6) \
		$(use_enable tcpd libwrap)
}

src_test() {
	TMPDIR="${T}" emake test
}

src_install() {
	default

	dodoc BUGREPORTS CHANGES DEVELOPMENT \
		FAQ FILES PORTING README SECURITY VERSION
	docinto examples
	dodoc EXAMPLES *.sh
	dohtml doc/*.html doc/*.css
}
