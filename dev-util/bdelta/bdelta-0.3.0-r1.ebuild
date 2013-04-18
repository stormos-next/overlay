# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bdelta/bdelta-0.3.0-r1.ebuild,v 1.1 2012/10/02 21:52:26 slyfox Exp $

EAPI=4

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/jjwhitney/BDelta.git"
	UNPACKER_ECLASS="git-2"
	LIVE_EBUILD=yes
else
	UNPACKER_ECLASS="vcs-snapshot"
fi

inherit eutils multilib toolchain-funcs ${UNPACKER_ECLASS}

if [[ -z ${LIVE_EBUILD} ]]; then
	KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-linux"
	SRC_URI="http://github.com/jjwhitney/BDelta/tarball/v${PV} -> ${P}.tar.gz"
fi

DESCRIPTION="Binary Delta - Efficient difference algorithm and format"
HOMEPAGE="http://bdelta.org"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-soname.patch
}

src_compile() {
	emake -C src \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake -C src install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	dodoc README Format
}
