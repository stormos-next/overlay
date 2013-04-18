# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/skrooge/skrooge-1.6.0.ebuild,v 1.4 2013/04/13 16:55:38 ago Exp $

EAPI=5

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu it
ja ko lt ms nb nds nl pl pt pt_BR ro ru sk sv tr ug uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="personal finances manager for KDE4, aiming at being simple and intuitive"
HOMEPAGE="http://www.skrooge.org/"
SRC_URI="http://www.skrooge.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop')
	app-crypt/qca:2
	dev-db/sqlite:3
	dev-libs/grantlee
	>=dev-libs/libofx-0.9.1
	dev-qt/qtsql:4[sqlite]
"
RDEPEND="${DEPEND}
	|| (
		( $(add_kdebase_dep kde-dev-scripts) )
		( $(add_kdebase_dep kdesdk-scripts) )
	)
"

# upstream does not ship tests in releases
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	RESTRICT="test"
fi

DOCS=( AUTHORS CHANGELOG README TODO )

src_prepare() {
	if [[ ${KDE_BUILD_TYPE} != live ]]; then
		# KDE_LINGUAS is also used to install appropriate handbooks
		# since there is no en_US 'translation', it cannot be added
		# hence making this impossible to install
		mv doc/en_US doc/en || die "doc move failed"
		sed -i -e 's/en_US/en/' doc/CMakeLists.txt || die "sed failed"
	fi

	kde4-base_src_prepare
}

src_test() {
	local mycmakeargs=(
		-DSKG_BUILD_TEST=ON
	)
	kde4-base_src_test
}
