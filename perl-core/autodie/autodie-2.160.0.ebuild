# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/autodie/autodie-2.160.0.ebuild,v 1.1 2013/03/02 08:38:17 tove Exp $

EAPI=5

MODULE_AUTHOR=PJF
MODULE_VERSION=2.16
inherit perl-module

DESCRIPTION='Replace functions with ones that succeed or die with lexical scope'

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
