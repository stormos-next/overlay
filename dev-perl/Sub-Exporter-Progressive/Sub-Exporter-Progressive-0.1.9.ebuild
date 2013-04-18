# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sub-Exporter-Progressive/Sub-Exporter-Progressive-0.1.9.ebuild,v 1.1 2013/03/17 17:37:23 tove Exp $

EAPI=5

MODULE_AUTHOR=FREW
MODULE_VERSION=0.001009
inherit perl-module

DESCRIPTION="Only use Sub::Exporter if you need it"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST=do
