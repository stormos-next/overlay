# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/chronic/chronic-0.9.1.ebuild,v 1.1 2013/02/28 07:34:00 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ree18 jruby ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

RUBY_FAKEGEM_GEMSPEC="chronic.gemspec"

inherit ruby-fakegem

DESCRIPTION="Chronic is a natural language date/time parser written in pure Ruby."
HOMEPAGE="https://github.com/mojombo/chronic"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' chronic.gemspec || die
}
