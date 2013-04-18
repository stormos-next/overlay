# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cairo/Cairo-1.90.0.ebuild,v 1.7 2012/05/28 14:12:34 armin76 Exp $

EAPI=4

MODULE_AUTHOR=XAOC
MODULE_VERSION=1.090
inherit perl-module

DESCRIPTION="Perl interface to the cairo library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"

RDEPEND="
	>=x11-libs/cairo-1.0.0
"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.205.0
	>=dev-perl/extutils-pkgconfig-1.70.0
	test? (
		dev-perl/Test-Number-Delta
	)
"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	sed -i -e 's,exit 0,exit 1,' "${S}"/Makefile.PL || die
}
