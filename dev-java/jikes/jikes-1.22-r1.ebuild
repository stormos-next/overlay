# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jikes/jikes-1.22-r1.ebuild,v 1.19 2011/01/23 14:33:14 armin76 Exp $

inherit base flag-o-matic eutils

DESCRIPTION="IBM's open source, high performance Java compiler"
HOMEPAGE="http://jikes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="IBM"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
DEPEND=""

PATCHES="${FILESDIR}/deprecated.patch"

src_compile() {
	filter-flags "-fno-rtti"
	econf || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die "install problem"
	dodoc ChangeLog AUTHORS README TODO NEWS
}
