# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libusbx/libusbx-1.0.14.ebuild,v 1.3 2013/02/17 20:41:35 zmedico Exp $

EAPI=4
inherit eutils

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="http://libusbx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 -x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc static-libs"

RDEPEND="!dev-libs/libusb:1"
DEPEND="doc? ( app-doc/doxygen )"

DOCS="AUTHORS NEWS PORTING README THANKS TODO"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug debug-log)
}

src_compile() {
	default

	use doc && emake -C doc docs
}

src_install() {
	default

	if use doc; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c

		dohtml doc/html/*
	fi

	prune_libtool_files
}
