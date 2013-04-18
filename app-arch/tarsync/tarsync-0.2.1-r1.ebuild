# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tarsync/tarsync-0.2.1-r1.ebuild,v 1.1 2010/08/11 08:30:41 ferringb Exp $

EAPI=2
DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="http://gentooexperimental.org/~ferringb/tarsync/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~hppa ~ppc ~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${PN}"

DEPEND=">=dev-util/diffball-0.7"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's:gcc \$(CFLAGS):gcc \$(CFLAGS) $(LDFLAGS):' Makefile || die "failed sed'ing to enable LDFLAGS"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "failed installing"
}
