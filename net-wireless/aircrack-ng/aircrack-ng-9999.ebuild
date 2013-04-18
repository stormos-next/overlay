# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/aircrack-ng/aircrack-ng-9999.ebuild,v 1.1 2013/04/12 03:27:55 zerochaos Exp $

EAPI="5"

inherit toolchain-funcs versionator subversion

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"
ESVN_REPO_URI="http://trac.aircrack-ng.org/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="+airdrop-ng +airgraph-ng kernel_linux kernel_FreeBSD netlink +sqlite +unstable"

DEPEND="dev-libs/openssl
	netlink? ( dev-libs/libnl:3 )
	sqlite? ( >=dev-db/sqlite-3.4 )"
RDEPEND="${DEPEND}
	kernel_linux? (
		net-wireless/iw
		net-wireless/wireless-tools
		sys-apps/ethtool
		sys-apps/usbutils
		sys-apps/pciutils )
	net-misc/ieee-oui
	airdrop-ng? ( net-wireless/lorcon[python] )"

S="${WORKDIR}/${PN}"

subversion_src_prepare() {
	subversion_bootstrap || die "${ESVN}: unknown problem occurred in subversion_bootstrap."
}

src_compile() {
	emake \
	CC="$(tc-getCC)" \
	AR="$(tc-getAR)" \
	LD="$(tc-getLD)" \
	RANLIB="$(tc-getRANLIB)" \
	libnl=$(usex netlink true false) \
	sqlite=$(usex sqlite true false) \
	unstable=$(usex unstable true false) \
	REVFLAGS=-D_REVISION="${ESVN_WC_REVISION}"
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		libnl=$(usex netlink true false) \
		sqlite=$(usex sqlite true false) \
		unstable=$(usex unstable true false) \
		REVFLAGS=-D_REVISION="${ESVN_WC_REVISION}" \
		install

	dodoc AUTHORS ChangeLog INSTALLING README

	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng"
		emake prefix="${ED}/usr" install
	fi
	if use airdrop-ng; then
		cd "${S}/scripts/airdrop-ng"
		emake prefix="${ED}/usr" install
	fi
}

pkg_postinst() {
	# Message is (c) FreeBSD
	# http://www.freebsd.org/cgi/cvsweb.cgi/ports/net-mgmt/aircrack-ng/files/pkg-message.in?rev=1.5
	if use kernel_FreeBSD ; then
		einfo "Contrary to Linux, it is not necessary to use airmon-ng to enable the monitor"
		einfo "mode of your wireless card.  So do not care about what the manpages say about"
		einfo "airmon-ng, airodump-ng sets monitor mode automatically."
		echo
		einfo "To return from monitor mode, issue the following command:"
		einfo "    ifconfig \${INTERFACE} -mediaopt monitor"
		einfo
		einfo "For aireplay-ng you need FreeBSD >= 7.0."
	fi
}
