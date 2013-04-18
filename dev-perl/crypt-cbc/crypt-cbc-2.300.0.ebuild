# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-cbc/crypt-cbc-2.300.0.ebuild,v 1.8 2012/03/25 17:30:35 armin76 Exp $

EAPI=4

MY_PN=Crypt-CBC
MODULE_AUTHOR=LDS
MODULE_VERSION=2.30
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/crypt-idea
	)"
#		dev-perl/Crypt-Rijndael"

SRC_TEST="do"
