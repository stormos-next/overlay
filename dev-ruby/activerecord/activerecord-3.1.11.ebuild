# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord/activerecord-3.1.11.ebuild,v 1.1 2013/02/11 20:48:05 graaff Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18"

# this is not null so that the dependencies will actually be filled
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activerecord.gemspec"

inherit ruby-fakegem

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="http://rubyforge.org/projects/activerecord/"
SRC_URI="http://github.com/rails/rails/tarball/v${PV} -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="mysql postgres sqlite3"

RUBY_S="rails-rails-*/activerecord"

ruby_add_rdepend "~dev-ruby/activesupport-${PV}
	~dev-ruby/activemodel-${PV}
	>=dev-ruby/arel-2.2.3:2.1
	>=dev-ruby/tzinfo-0.3.29
	sqlite3? ( >=dev-ruby/sqlite3-1.3.4 )
	mysql? ( >=dev-ruby/mysql2-0.3.6:0.3 )
	postgres? ( >=dev-ruby/pg-0.11.0 )"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		~dev-ruby/actionpack-${PV}
		>=dev-ruby/sqlite3-1.3.3
		>=dev-ruby/mocha-0.13.0
		virtual/ruby-test-unit
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e '/\(uglifier\|system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|"mysql"\|ruby-prof\|benchmark-ips\)/d' ../Gemfile || die
	sed -i -e '/\(rack-ssl\|thor\)/d' ../railties/railties.gemspec || die
	sed -i -e '/mail/d' ../actionmailer/actionmailer.gemspec || die
	sed -i -e "s/, '< 1.3'//" ../activesupport/activesupport.gemspec || die
}

each_ruby_test() {
	case ${RUBY} in
		*jruby)
			;;
		*)
			if use sqlite3; then
				TRAVIS=true ${RUBY} -S rake test_sqlite3 || die "sqlite3 tests failed"
			fi
			;;
	esac
}
