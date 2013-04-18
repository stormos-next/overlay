# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/kencfs/kencfs-1.2.ebuild,v 1.3 2013/03/02 19:14:26 hwoarang Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="http://kde-apps.org/content/show.php?content=134003"
SRC_URI="http://kde-apps.org/CONTENT/content-files/134003-${P}.tar.gz"
IUSE=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="kde-base/kdelibs
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}
	sys-fs/encfs
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-underlinking.patch"
	"${FILESDIR}/${P}-gcc-4.7.patch"
)
