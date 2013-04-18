# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mirage2iso/mirage2iso-0.4.ebuild,v 1.1 2013/01/28 23:03:47 mgorny Exp $

EAPI=4

inherit autotools-utils versionator

TESTS_PV=0.3

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="https://bitbucket.org/mgorny/mirage2iso/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2
	test? ( mirror://bitbucket/mgorny/${PN}/downloads/${PN}-${TESTS_PV}-tests.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pinentry test"

COMMON_DEPEND=">=dev-libs/libmirage-2.0.0
	dev-libs/glib:2
	pinentry? ( dev-libs/libassuan )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? ( app-arch/xz-utils )"
RDEPEND="${COMMON_DEPEND}
	pinentry? ( app-crypt/pinentry )"

src_configure() {
	myeconfargs=(
		$(use_with pinentry libassuan)
	)

	autotools-utils_src_configure
}

src_test() {
	mv "${WORKDIR}"/${PN}-${TESTS_PV}/tests/* tests/ || die
	autotools-utils_src_test
}
