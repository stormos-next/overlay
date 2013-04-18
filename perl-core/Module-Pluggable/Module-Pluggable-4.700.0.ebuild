# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Module-Pluggable/Module-Pluggable-4.700.0.ebuild,v 1.1 2013/03/13 08:13:12 tove Exp $

EAPI=5

MODULE_AUTHOR=SIMONW
MODULE_VERSION=4.7
inherit perl-module

DESCRIPTION="automatically give your module the ability to have plugins"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
"

SRC_TEST="do"
