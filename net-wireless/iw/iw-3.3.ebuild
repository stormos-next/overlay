# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iw/iw-3.3.ebuild,v 1.8 2012/12/16 21:10:08 zerochaos Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="nl80211-based configuration utility for wireless devices using the mac80211 kernel stack"
HOMEPAGE="http://wireless.kernel.org/en/users/Documentation/iw"
SRC_URI="http://linuxwireless.org/download/${PN}/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/libnl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	tc-export CC LD
}

src_compile() {
	emake V=1
}

src_install() {
	emake install DESTDIR="${D}" || die
}
