# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/rubygfe/rubygfe-0.3.4-r1.ebuild,v 1.1 2010/05/22 20:11:44 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18"

inherit ruby-ng

DESCRIPTION="RubyGFE - A Game File Extractor"
HOMEPAGE="http://rubyforge.org/projects/rubygfe/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls gtk"

ruby_add_rdepend "
	gtk? ( >=dev-ruby/ruby-gtk2-0.12.0 )
	nls? ( >=dev-ruby/ruby-gettext-0.8.0 )
	>=dev-ruby/rubyzip-0.5.7"

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" || die
}

all_ruby_install() {
	dodoc README HACKING ChangeLog TODO || die
}
