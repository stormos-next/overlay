# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/libnfs/libnfs-1.5.0.ebuild,v 1.1 2012/12/04 03:54:39 vapier Exp $

EAPI="4"

inherit eutils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/sahlberg/libnfs.git"
	inherit git-2 autotools
else
	SRC_URI="https://github.com/downloads/sahlberg/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	default
	[[ ${PV} == "9999" ]] && git-2_src_unpack
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	epatch "${FILESDIR}"/${PN}-1.5.0-headers.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
