# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgconf/pkgconf-9999.ebuild,v 1.12 2012/10/17 15:51:49 ryao Exp $

EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/pkgconf/pkgconf.git"
	inherit autotools git-2
else
	inherit autotools vcs-snapshot
	SRC_URI="https://github.com/pkgconf/pkgconf/tarball/${P} -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd"
fi

DESCRIPTION="pkg-config compatible replacement with no dependencies other than ANSI C89"
HOMEPAGE="https://github.com/pkgconf/pkgconf"

LICENSE="BSD-1"
SLOT="0"
IUSE="+pkg-config strict"

DEPEND=""
RDEPEND="${DEPEND}
	pkg-config? (
		!dev-util/pkgconfig
		!dev-util/pkg-config-lite
		!dev-util/pkgconfig-openbsd[pkg-config]
	)"

src_prepare() {
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf $(use_enable strict)
}

src_install() {
	default
	use pkg-config \
		&& dosym pkgconf /usr/bin/pkg-config \
		|| rm "${ED}"/usr/share/aclocal/pkg.m4 \
		|| die
}
