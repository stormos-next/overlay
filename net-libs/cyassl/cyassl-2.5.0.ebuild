# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cyassl/cyassl-2.5.0.ebuild,v 1.10 2013/03/07 07:26:17 vapier Exp $

EAPI="5"

inherit eutils

DESCRIPTION="Lightweight SSL/TLS library targeted at embedded and RTOS environments"
HOMEPAGE="http://www.yassl.com/yaSSL/Home.html"
SRC_URI="http://dev.gentoo.org/~blueness/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 s390 x86"

#Add CRYPTO_OPTS=ecc when fixed
CACHE_SIZE="small big +huge"
CRYPTO_OPTS="aes-gcm aes-ccm aes-ni camellia +hc128 md2 +psk +ripemd sha512"
CERT_OPTS="ocsp crl crl-monitor +sessioncerts +testcert"
IUSE="debug -dtls ipv6 +httpd +sniffer static-libs threads +zlib cyassl-hardening ${CACHE_SIZE} ${CRYPTO_OPTS} ${CERT_OPTS} test"

#You can only pick one cach size
#sha512 is broken on x86
#Testing freezes with dtls
REQUIRED_USE="^^ ( small big huge )
	test? ( !dtls )"

DEPEND="app-arch/unzip
	sniffer? ( net-libs/libpcap )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.8-disable-testsuit-ifnothreads.patch
}

src_configure() {
	local myconf=()

	if use threads; then
		myconf+=( --disable-singleThreaded )
	else
		myconf+=( --enable-singleThreaded )
	fi

	if use amd64; then
		myconf+=( --enable-fastmath --enable-fasthugemath --enable-bump )
	elif use x86; then
		#not pie friendly, sorry x86, no fast math for you :(
		myconf+=( --disable-fastmath --disable-fasthugemath --disable-bump )
	fi

	#Bug #454300
	export C_EXTRA_FLAGS=${CFLAGS}

	#There are lots of options, so we'll force a few reasonable
	#We may change this in the future, in particular ecc needs to be fixed
	econf \
		--disable-silent-rules              \
		--enable-opensslExtra               \
		--enable-fortress                   \
		--enable-keygen                     \
		--enable-certgen                    \
		--disable-debug                     \
		--disable-ecc                       \
		--disable-ntru                      \
		--disable-noFilesystem              \
		--disable-noInline                  \
		$(use_enable debug)                 \
		$(use_enable small smallcache)      \
		$(use_enable big bigcache)          \
		$(use_enable huge hugecache)        \
		$(use_enable aes-gcm aesgcm)        \
		$(use_enable aes-ccm aesccm)        \
		$(use_enable aes-ni aesni)          \
		$(use_enable camellia)              \
		$(use_enable hc128)                 \
		$(use_enable md2)                   \
		$(use_enable psk)                   \
		$(use_enable ripemd)                \
		$(use_enable sha512)                \
		$(use_enable dtls)                  \
		$(use_enable ipv6)                  \
		$(use_enable httpd webServer)       \
		$(use_enable ocsp)                  \
		$(use_enable crl)                   \
		$(use_enable crl-monitor)           \
		$(use_enable sessioncerts)          \
		$(use_enable sniffer)               \
		$(use_enable testcert)              \
		$(use_enable static-libs static)    \
		$(use_enable cyassl-hardening gcc-hardening)    \
		$(use_with zlib libz)               \
		"${myconf[@]}"
}

src_test() {
	"${S}"/tests/unit
	"${S}"/ctaocrypt/benchmark/benchmark
}

src_install() {
	default

	mv "${D}"/usr/share/doc/"${PN}"/* \
		"${D}"/usr/share/doc/"${P}"/
	rmdir "${D}"/usr/share/doc/"${PN}"/
}
