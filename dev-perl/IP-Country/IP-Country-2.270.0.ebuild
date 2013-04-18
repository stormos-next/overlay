# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IP-Country/IP-Country-2.270.0.ebuild,v 1.2 2012/03/25 15:08:52 armin76 Exp $

EAPI=4

MODULE_AUTHOR=NWETTERS
MODULE_VERSION=2.27
inherit perl-module

DESCRIPTION="fast lookup of country codes from IP addresses"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="dev-perl/Geography-Countries"
DEPEND="${RDEPEND}"

SRC_TEST="do"
