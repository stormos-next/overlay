# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haxml/haxml-1.13.2.ebuild,v 1.9 2007/12/13 17:57:57 dcoutts Exp $

CABAL_FEATURES="lib bin profile haddock"
inherit base haskell-cabal versionator

MY_PN=HaXml
MY_P=${MY_PN}-${PV}

DESCRIPTION="Haskell utilities for parsing, filtering, transforming and generating XML documents"
HOMEPAGE="http://www.haskell.org/HaXml/"
SRC_URI="http://www.haskell.org/HaXml/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"

IUSE=""

# actually, >=ghc-5.02 should be ok (if not using cabal)
# hugs and nhc98 are ok too, somebody might want to add support for them
DEPEND=">=dev-lang/ghc-6.2
		>=dev-haskell/cabal-1.1.3-r1"

S=${WORKDIR}/${MY_P}

src_unpack() {
	base_src_unpack

	# Don't warn so much, and don't compile with -O2
	sed -i 's/GHC-Options: -Wall -O2/GHC-Options: -O/' "${S}/HaXml.cabal"

	# Add in the extra split-base deps
	if version_is_at_least "6.8" "$(ghc-version)"; then
		sed -i -e '/build-depends:/a \
			, pretty, containers' \
			"${S}/HaXml.cabal"
	fi
}

src_install() {
	cabal_src_install

	if use doc; then
		dohtml -r docs/*
		dodoc docs/icfp99.dvi docs/icfp99.ps.gz
	fi
}
