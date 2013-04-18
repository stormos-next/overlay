# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/mailfilter/mailfilter-0.8.2.ebuild,v 1.6 2012/03/19 09:01:10 xarthisius Exp $

EAPI=2
inherit eutils

DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
HOMEPAGE="http://mailfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/0.8.2-gcc44.patch \
		"${FILESDIR}"/0.8.2-openssl-1.patch \
		"${FILESDIR}"/${PV}-gcc46.patch
}

src_compile() {
	emake -j1 || die #281069
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc INSTALL doc/FAQ "${FILESDIR}"/rcfile.example{1,2} \
		README THANKS ChangeLog AUTHORS NEWS || die
}
