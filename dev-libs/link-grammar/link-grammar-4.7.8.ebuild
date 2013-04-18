# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/link-grammar/link-grammar-4.7.8.ebuild,v 1.10 2013/04/01 18:24:10 ago Exp $

EAPI=4
inherit java-pkg-opt-2 eutils

DESCRIPTION="Link Grammar Parser is a syntactic English parser."
HOMEPAGE="http://www.abisource.com/projects/link-grammar/ http://www.link.cs.cmu.edu/link/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"

# Set the same default as used in app-text/enchant
IUSE="aspell +hunspell java static-libs threads"

DEPEND="aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	java? ( >=virtual/jdk-1.5
		dev-java/ant-core )"
RDEPEND="${DEPEND}"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only aspell will be build. Press Ctrl+C and set only 'hunspell' USE flag if"
		ewarn "you want hunspell support."
	fi
}

src_configure() {
	local myconf

	use hunspell && myconf="${myconf} --with-hunspell-dictdir=/usr/share/myspell"
	econf \
		--enable-shared \
		$(use_enable aspell) \
		$(use_enable hunspell) \
		$(use_enable java java-bindings) \
		$(use_enable static-libs static) \
		$(use_enable threads pthreads) \
		${myconf}
}

src_install() {
	default
	prune_libtool_files
}
