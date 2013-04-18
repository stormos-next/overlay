# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-debug-base/ruby-debug-base-0.10.4.ebuild,v 1.5 2012/05/01 18:24:03 armin76 Exp $

EAPI="2"
USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGES README"

inherit ruby-fakegem

DESCRIPTION="Fast Ruby debugger"
HOMEPAGE="http://rubyforge.org/projects/ruby-debug/"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""
SLOT="0"

ruby_add_rdepend ">=dev-ruby/linecache-0.3"

each_ruby_configure() {
	${RUBY} -C ext extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -C ext || die "emake failed"
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_newins ext/ruby_debug.so lib/ruby_debug.so
}

all_ruby_install() {
	all_fakegem_install

	if use doc; then
		dohtml doc -r || die
	fi
}
