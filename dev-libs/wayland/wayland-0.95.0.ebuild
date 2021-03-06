# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/wayland/wayland-0.95.0.ebuild,v 1.4 2013/02/07 21:52:59 ulm Exp $

EAPI=4

EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit autotools toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
fi

LICENSE="CC-BY-SA-3.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/expat
	virtual/libffi"
DEPEND="${RDEPEND}
	dev-libs/libxslt"

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	if tc-is-cross-compiler ; then
		econf $(use_enable static-libs static) --disable-scanner
	else
		econf $(use_enable static-libs static)
	fi
}
