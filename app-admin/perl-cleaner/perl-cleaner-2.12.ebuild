# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/perl-cleaner/perl-cleaner-2.12.ebuild,v 1.1 2012/04/29 07:39:43 tove Exp $

EAPI=4

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-shells/bash
	|| ( >=sys-apps/coreutils-8.15 app-misc/realpath sys-freebsd/freebsd-bin )
	dev-lang/perl"

src_install() {
	dosbin perl-cleaner
	doman perl-cleaner.1
}
