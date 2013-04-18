# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/enca/enca-1.13-r2.ebuild,v 1.9 2012/05/15 13:01:08 aballier Exp $

EAPI="4"

inherit toolchain-funcs autotools-utils

DESCRIPTION="ENCA detects the character coding of a file and converts it if desired"
HOMEPAGE="http://gitorious.org/enca"
SRC_URI="http://dl.cihar.com/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +recode"

DEPEND="recode? ( >=app-text/recode-3.6_p15 )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--enable-external
		--disable-static
		$(use_with recode librecode "${EPREFIX}"/usr)
		$(use_enable doc gtk-doc)
	)
	autotools-utils_src_configure
}

src_compile() {
	if tc-is-cross-compiler; then
		pushd tools > /dev/null
		$(tc-getBUILD_CC) -o make_hash make_hash.c || die "native make_hash failed"
		popd > /dev/null
	fi
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install
}
