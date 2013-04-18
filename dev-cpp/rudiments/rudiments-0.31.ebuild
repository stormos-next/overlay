# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/rudiments/rudiments-0.31.ebuild,v 1.1 2008/04/04 01:10:49 halcy0n Exp $

DESCRIPTION="C++ class library for daemons, clients and servers"
HOMEPAGE="http://rudiments.sourceforge.net/"
SRC_URI="mirror://sourceforge/rudiments/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="debug pcre ssl"

DEPEND="pcre? ( dev-libs/libpcre )
		ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_compile() {
	# It's a buggy configure-script
	# We can only disable, but not enable
	local options
	use pcre || options="${options} --disable-pcre"
	use ssl || options="${options} --disable-ssl"
	econf \
		$(use_enable debug) \
		${options} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}/html" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
