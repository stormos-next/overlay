# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/haproxy/haproxy-1.5_beta18.ebuild,v 1.1 2013/04/04 19:06:24 idl0r Exp $

EAPI="4"

inherit user versionator toolchain-funcs flag-o-matic

MY_P="${PN}-${PV/_beta/-dev}"

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://haproxy.1wt.eu"
SRC_URI="http://haproxy.1wt.eu/download/$(get_version_component_range 1-2)/src/devel/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+crypt examples +pcre ssl vim-syntax +zlib"

DEPEND="pcre? ( dev-libs/libpcre )
	ssl? ( dev-libs/openssl[zlib?] )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy
}

src_compile() {
	local args="TARGET=linux2628 USE_GETADDRINFO=1"

	if use pcre; then
		args="${args} USE_PCRE=1 USE_PCRE_JIT=1"
	else
		args="${args} USE_PCRE= USE_PCRE_JIT="
	fi

#	if use kernel_linux; then
#		args="${args} USE_LINUX_SPLICE=1 USE_LINUX_TPROXY=1"
#	else
#		args="${args} USE_LINUX_SPLICE= USE_LINUX_TPROXY="
#	fi

	if use crypt; then
		args="${args} USE_LIBCRYPT=1"
	else
		args="${args} USE_LIBCRYPT="
	fi

	if use ssl; then
		args="${args} USE_OPENSSL=1"
	else
		args="${args} USE_OPENSSL="
	fi

	if use zlib; then
		args="${args} USE_ZLIB=1"
	else
		args="${args} USE_ZLIB="
	fi

	# For now, until the strict-aliasing breakage will be fixed
#	append-cflags -fno-strict-aliasing

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args} || die
}

src_install() {
	dobin haproxy || die

	newinitd "${FILESDIR}/haproxy.initd-r2" haproxy || die

	# Don't install useless files
#	rm examples/build.cfg doc/*gpl.txt

	dodoc CHANGELOG ROADMAP TODO doc/{configuration,haproxy-en}.txt
	doman doc/haproxy.1

	if use examples;
	then
		docinto examples
		dodoc examples/*.cfg || die
	fi

	if use vim-syntax;
	then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/haproxy.vim || die
	fi
}

pkg_postinst() {
	if [[ ! -f "${ROOT}/etc/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${ROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${ROOT}usr/share/doc/${PF}"
		fi
	fi
}
