# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/kdesvn/kdesvn-1.5.5-r2.ebuild,v 1.4 2013/03/02 21:08:28 hwoarang Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_LINGUAS="de es fr ja lt pt_BR ro"
KDE_LINGUAS_LIVE_OVERRIDE="true"
inherit flag-o-matic kde4-base

DESCRIPTION="KDESvn is a frontend to the subversion vcs."
HOMEPAGE="http://kdesvn.alwins-world.de/"
if [[ ${PV} = 9999* ]]; then
	ESVN_REPO_URI="http://www.alwins-world.de/repos/kdesvn/trunk/"
	ESVN_PROJECT="kdesvn"
else
	SRC_URI="http://kdesvn.alwins-world.de/downloads/${P}.tar.bz2"
fi

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

DEPEND="
	dev-libs/apr:1
	dev-libs/apr-util:1
	>=dev-vcs/subversion-1.4
	sys-devel/gettext
	dev-qt/qtsql:4[sqlite]
"
RDEPEND="${DEPEND}"

add_blocker "kdesdk-kioslaves[subversion(+)]"

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.7.patch"
	"${FILESDIR}/${P}-qt48.patch"
)

src_configure() {
	append-cppflags -DQT_THREAD_SUPPORT

	[[ ${PV} = 9999* ]] && mycmakeargs=(-DDAILY_BUILD=ON)

	kde4-base_src_configure
}
