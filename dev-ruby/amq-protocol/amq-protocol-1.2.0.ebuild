# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amq-protocol/amq-protocol-1.2.0.ebuild,v 1.1 2013/02/23 08:48:59 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="An AMQP 0.9.1 serialization library for Ruby."
HOMEPAGE="http://github.com/ruby-amqp/amq-protocol"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/bundler/d' spec/spec_helper.rb || die
}
