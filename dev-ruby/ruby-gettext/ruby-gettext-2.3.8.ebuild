# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gettext/ruby-gettext-2.3.8.ebuild,v 1.2 2013/04/15 09:21:56 jer Exp $

EAPI=5

USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_NAME="${PN/ruby-/}"
RUBY_FAKEGEM_VERSION="${PV%_*}"

RUBY_FAKEGEM_TASK_DOC="yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRAINSTALL="po"

inherit ruby-fakegem

DESCRIPTION="Ruby GetText Package is Native Language Support Library and Tools modeled after GNU gettext package"
HOMEPAGE="http://www.yotabanana.com/hiki/ruby-gettext.html"

KEYWORDS="~amd64 ~hppa"
IUSE="doc test"
SLOT="0"
LICENSE="Ruby"

ruby_add_rdepend ">=dev-ruby/locale-2.0.5 dev-ruby/levenshtein"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	dev-ruby/racc"
ruby_add_bdepend "test? ( dev-ruby/test-unit-rr )"

RDEPEND+=" sys-devel/gettext"
DEPEND+=" sys-devel/gettext"

all_ruby_prepare() {
	# Fix broken racc invocation
	sed -i -e '/command_line/ s/#{racc}/-S racc/' Rakefile || die

	# Avoid bundler dependency
	sed -i -e '/bundler/,/helper.install/ s:^:#:' \
		-e 's/helper.gemspec/Gem::Specification.new/' Rakefile || die

	# Avoid dependency on developer-specific tools.
	sed -i -e '/notify/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	# Upstream tries to daisy-chain rake calls but they fail badly
	# with our setup, so run it manually.
	${RUBY} test/run-test.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r samples
}
