# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Package-Stash/Package-Stash-0.340.0.ebuild,v 1.1 2013/01/06 09:53:47 tove Exp $

EAPI=5

MODULE_AUTHOR=DOY
MODULE_VERSION=0.34
inherit perl-module

DESCRIPTION="Routines for manipulating stashes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Dist-CheckConflicts-0.20.0
	>=dev-perl/Module-Implementation-0.60.0
	dev-perl/Package-DeprecationManager
	>=dev-perl/Package-Stash-XS-0.260.0
"
# conflicts:
#	!<=dev-perl/Class-MOP-1.08
#	!<=dev-perl/namespace-clean-0.18
#	!<=dev-perl/MooseX-Role-WithOverloading-0.80
#	!<=dev-perl/MooseX-Method-Signatures-0.360.0

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST="do"
