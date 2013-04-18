# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Exception/Test-Exception-0.310.0.ebuild,v 1.8 2012/03/25 17:09:29 armin76 Exp $

EAPI=4

MODULE_AUTHOR=ADIE
MODULE_VERSION=0.31
inherit perl-module

DESCRIPTION="test functions for exception based code"

SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/perl-Test-Simple-0.64
	>=dev-perl/Sub-Uplevel-0.18"
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.36"

SRC_TEST="do"
