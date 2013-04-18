# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/UNIVERSAL-require/UNIVERSAL-require-0.130.0.ebuild,v 1.3 2013/02/18 23:47:10 zmedico Exp $

EAPI=4

MODULE_AUTHOR=MSCHWERN
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="UNIVERSAL::require - require() modules from a variable"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

SRC_TEST="do"
