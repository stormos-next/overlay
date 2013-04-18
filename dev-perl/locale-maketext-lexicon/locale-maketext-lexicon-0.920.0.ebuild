# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/locale-maketext-lexicon/locale-maketext-lexicon-0.920.0.ebuild,v 1.7 2013/04/02 11:19:47 ago Exp $

EAPI=4

MY_PN=Locale-Maketext-Lexicon
MODULE_AUTHOR=AUDREYT
MODULE_VERSION=0.92
inherit perl-module

DESCRIPTION="Use other catalog formats in Maketext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc sparc x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	>=virtual/perl-locale-maketext-1.170.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
