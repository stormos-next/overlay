# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PHPUnit_MockObject/PHPUnit_MockObject-1.1.1.ebuild,v 1.4 2012/10/17 03:16:50 phajdan.jr Exp $

EAPI=4

PEAR_PV="1.1.1"
PHP_PEAR_PKG_NAME="PHPUnit_MockObject"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHPUnit_MockObject"

inherit php-pear-r1

DESCRIPTION="Mock Object library for PHPUnit"
HOMEPAGE="pear.phpunit.de"
SRC_URI="http://pear.phpunit.de/get/PHPUnit_MockObject-1.1.1.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-php/pear-1.9.4
	>=dev-php/Text_Template-1.1.1"
RDEPEND="${DEPEND}"
