# Copyright 2010-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoind/bitcoind-0.7.3_rc2.ebuild,v 1.2 2013/04/14 18:49:43 blueness Exp $

EAPI="4"

DB_VER="4.8"

inherit db-use eutils versionator toolchain-funcs

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="http://gitorious.org/bitcoin/bitcoind-stable/archive-tarball/v${PV/_/} -> bitcoin-v${PV}.tgz
"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples ipv6 logrotate upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	logrotate? (
		app-admin/logrotate
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/bitcoin-bitcoind-stable"

pkg_setup() {
	local UG='bitcoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoin "${UG}"
}

src_compile() {
	OPTS=()

	OPTS+=("DEBUGFLAGS=")
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=("LDFLAGS=${LDFLAGS}")

	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	if use upnp; then
		OPTS+=(USE_UPNP=1)
	else
		OPTS+=(USE_UPNP=)
	fi
	use ipv6 || OPTS+=("USE_IPV6=-")

	# Workaround for bug #440034
	share/genbuild.sh src/obj/build.h

	cd src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" ${PN}
}

src_test() {
	cd src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" test_bitcoin
	./test_bitcoin || die 'Tests failed'
}

src_install() {
	dobin src/${PN}

	insinto /etc/bitcoin
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
	fperms 600 /etc/bitcoin/bitcoin.conf

	newconfd "${FILESDIR}/bitcoin.confd" ${PN}
	newinitd "${FILESDIR}/bitcoin.initd" ${PN}

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym /etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

	dodoc doc/README

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,pyminer,wallettools}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoind.logrotate" bitcoind
	fi
}
