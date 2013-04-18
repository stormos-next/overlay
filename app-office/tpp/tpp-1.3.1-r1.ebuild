# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/tpp/tpp-1.3.1-r1.ebuild,v 1.3 2011/06/24 21:00:14 ranger Exp $

EAPI=2
USE_RUBY="ruby18"

inherit eutils ruby-ng

DESCRIPTION="An ncurses-based presentation tool."
HOMEPAGE="http://synflood.at/tpp.html"
SRC_URI="http://synflood.at/tpp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="figlet"

RDEPEND="${RDEPEND}	figlet? ( app-misc/figlet )"

ruby_add_rdepend "dev-ruby/ncurses-ruby"

RUBY_PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

each_ruby_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
