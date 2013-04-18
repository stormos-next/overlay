# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xcache/xcache-2.0.0.ebuild,v 1.4 2012/10/21 09:15:01 maekke Exp $

EAPI="4"
PHP_EXT_NAME="xcache"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"
PHPSAPILIST="apache2 cgi fpm"

USE_PHP="php5-3 php5-4"
inherit php-ext-source-r2 confutils

DESCRIPTION="A fast and stable PHP opcode cacher"
HOMEPAGE="http://xcache.lighttpd.net/"
SRC_URI="http://xcache.lighttpd.net/pub/Releases/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# make test would just run php's test and as such need the full php source
RESTRICT="test"

DEPEND="virtual/httpd-php
!dev-php/eaccelerator !dev-php/pecl-apc"
RDEPEND="${DEPEND}"

src_configure() {

	my_conf="--enable-xcache=shared   \
			--enable-xcache-constant  \
			--enable-xcache-optimizer \
			--enable-xcache-coverager \
			--enable-xcache-assembler \
			--enable-xcache-encoder   \
			--enable-xcache-decoder"

	php-ext-source-r2_src_configure
}

src_install() {
	php-ext-source-r2_src_install
	dodoc AUTHORS ChangeLog NEWS README THANKS

	php-ext-source-r2_addtoinifiles "xcache.admin.enable_auth" '"On"'
	php-ext-source-r2_addtoinifiles "xcache.admin.user" '"admin"'
	php-ext-source-r2_addtoinifiles "xcache.admin.pass" '""'

	php-ext-source-r2_addtoinifiles "xcache.cacher" '"On"'
	php-ext-source-r2_addtoinifiles "xcache.size" '"64M"'
	php-ext-source-r2_addtoinifiles "xcache.count" '"2"'
	php-ext-source-r2_addtoinifiles "xcache.slots" '"8k"'
	php-ext-source-r2_addtoinifiles "xcache.ttl" '"0"'
	php-ext-source-r2_addtoinifiles "xcache.gc_interval" '"0"'
	php-ext-source-r2_addtoinifiles "xcache.var_size" '"8M"'
	php-ext-source-r2_addtoinifiles "xcache.var_count" '"1"'
	php-ext-source-r2_addtoinifiles "xcache.var_slots" '"8K"'
	php-ext-source-r2_addtoinifiles "xcache.var_ttl" '"0"'
	php-ext-source-r2_addtoinifiles "xcache.var_maxttl" '"0"'
	php-ext-source-r2_addtoinifiles "xcache.var_gc_interval" '"600"'
	php-ext-source-r2_addtoinifiles "xcache.readonly_protection" '"Off"'
	php-ext-source-r2_addtoinifiles "xcache.mmap_path" '"/dev/zero"'

	php-ext-source-r2_addtoinifiles "xcache.coverager" '"Off"'
	php-ext-source-r2_addtoinifiles "xcache.coveragedump_directory" '""'

	php-ext-source-r2_addtoinifiles "xcache.optimizer" '"Off"'

	insinto "${PHP_EXT_SHARED_DIR}"
	doins Decompiler.class.php
	insinto "${PHP_EXT_SHARED_DIR}/admin"
	doins admin/*
	insinto "${PHP_EXT_SHARED_DIR}/coverager"
	doins coverager/*
}

pkg_postinst() {
	elog "Decompiler.class.php, the admin/ and the coverager/ directory shipped with this"
	elog "release were installed into ${ROOT}usr/share/php5/xcache/."
}
