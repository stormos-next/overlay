# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/libusb/libusb-1.ebuild,v 1.22 2013/02/18 03:14:47 zmedico Exp $

EAPI=2

DESCRIPTION="Virtual for libusb"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=dev-libs/libusbx-1.0.13:1 >=dev-libs/libusb-1.0.9:1 >=sys-freebsd/freebsd-lib-9.1_rc3-r1[usb] )"
