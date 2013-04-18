# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/minbif/minbif-1.0.4.ebuild,v 1.1 2011/02/25 19:41:41 cedk Exp $

EAPI=2

inherit cmake-utils eutils

DESCRIPTION="an IRC gateway to IM networks"
HOMEPAGE="http://minbif.im/"
SRC_URI="http://symlink.me/attachments/download/90/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gnutls +imlib +libcaca pam video xinetd"

DEPEND=">=net-im/pidgin-2.6
	video? ( >=net-im/pidgin-2.6[gstreamer] net-libs/farsight2 )
	libcaca? ( media-libs/libcaca media-libs/imlib2 )
	imlib? ( media-libs/imlib2 )
	pam? ( sys-libs/pam )
	gnutls? ( net-libs/gnutls )"
RDEPEND="${DEPEND}
	virtual/logger
	xinetd? ( sys-apps/xinetd )"

src_prepare() {
	sed -i "s/-Werror//g" CMakeLists.txt || die "sed failed"

	sed -i "s#share/doc/minbif#share/doc/${P}#" \
		CMakeLists.txt || die "sed failed"

	if use xinetd; then
		sed -i "s/type\s=\s[0-9]/type = 0/" \
			minbif.conf || die "sed failed"
	fi
}

src_configure() {
	use video && ! use libcaca && \
		die "You need to enable libcaca if you enable video"

	local mycmakeargs
	mycmakeargs="${mycmakeargs}
		-DCONF_PREFIX=${PREFIX:-/etc/minbif}
		$(cmake-utils_use_enable libcaca CACA)
		$(cmake-utils_use_enable video VIDEO)
		$(cmake-utils_use_enable imlib IMLIB)
		$(cmake-utils_use_enable pam PAM)
		$(cmake-utils_use_enable gnutls TLS)"

	cmake-utils_src_configure
}

pkg_preinst() {
	enewgroup minbif
	enewuser minbif -1 -1 /var/lib/minbif minbif
}

src_install() {
	cmake-utils_src_install
	keepdir /var/lib/minbif
	fperms 700 /var/lib/minbif
	fowners minbif:minbif /var/lib/minbif

	dodoc ChangeLog README
	doman man/minbif.8

	if use xinetd; then
		insinto /etc/xinetd.d
		newins doc/minbif.xinetd minbif
	fi

	newinitd "${FILESDIR}"/minbif.initd minbif || die

	dodir /usr/share/minbif
	insinto /usr/share/minbif
	doins -r scripts
}
