# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haskell-src-exts/haskell-src-exts-1.9.0.ebuild,v 1.2 2012/09/12 15:07:36 qnikst Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer"
HOMEPAGE="http://code.haskell.org/haskell-src-exts"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-lang/ghc-6.6.1
		 >=dev-haskell/cpphs-1.3"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2
		>=dev-haskell/happy-1.17"
