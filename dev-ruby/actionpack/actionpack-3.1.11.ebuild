# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionpack/actionpack-3.1.11.ebuild,v 1.1 2013/02/11 20:47:30 graaff Exp $

EAPI=4

USE_RUBY="ruby18 ruby19 ree18"

# The default test task tries to test activerecord with SQLite as well.
RUBY_FAKEGEM_TASK_TEST="test_action_pack"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="actionpack.gemspec"

inherit ruby-fakegem

DESCRIPTION="Eases web-request routing, handling, and response."
HOMEPAGE="http://rubyforge.org/projects/actionpack/"
SRC_URI="http://github.com/rails/rails/tarball/v${PV} -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="rails-rails-*/actionpack"

ruby_add_rdepend "
	~dev-ruby/activemodel-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/rack-cache-1.2
	>=dev-ruby/builder-3.0.0:3
	>=dev-ruby/erubis-2.7.0
	>=dev-ruby/i18n-0.6:0.6
	>=dev-ruby/rack-1.3.6:1.3
	>=dev-ruby/rack-mount-0.8.2:0.8
	>=dev-ruby/rack-test-0.6.1:0.6
	>=dev-ruby/sprockets-2.0.4:2.0"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
		dev-ruby/bundler
		~dev-ruby/activerecord-${PV}
		~dev-ruby/actionmailer-${PV}
		>=dev-ruby/tzinfo-0.3.29
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e '/\(uglifier\|system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|"mysql"\|ruby-prof\|benchmark-ips\)/d' ../Gemfile || die

	sed -i -e '/\(rack-ssl\|thor\)/d' ../railties/railties.gemspec || die
	sed -i -e '/mail/d' ../actionmailer/actionmailer.gemspec || die
	sed -i -e "s/, '< 1.3'//" ../activesupport/activesupport.gemspec || die

	# Loosen mocha version restriction
	sed -i -e 's/0.10.5/>= 0.10.5/' ../Gemfile || die

	# Avoid fragile tests depending on hash ordering
	sed -i -e '/cookie_3=chocolate/ s:^:#:' test/controller/integration_test.rb || die
	sed -i -e '/test_to_s/,/end/ s:^:#:' test/template/html-scanner/tag_node_test.rb || die
	sed -i -e '/"name":"david"/ s:^:#:' test/controller/mime_responds_test.rb || die
	sed -i -e '/test_option_html_attributes_with_multiple_element_hash/, / end/ s:^:#:' test/template/form_options_helper_test.rb || die
	sed -i -e '/test_option_html_attributes_with_multiple_hashes/, / end/ s:^:#:' test/template/form_options_helper_test.rb || die
}
