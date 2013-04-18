# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/akonadi-facebook/akonadi-facebook-0_p20120827.ebuild,v 1.3 2013/02/08 03:24:05 creffett Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="Facebook services integration in Akonadi"
HOMEPAGE="https://projects.kde.org/akonadi-facebook"
SRC_URI="http://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs semantic-desktop)
	dev-libs/qjson
	kde-misc/akonadi-social-utils
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-libs/libxslt
	x11-misc/shared-mime-info
"

S=${WORKDIR}

PATCHES=( "${FILESDIR}/${P}-fix-includes.patch" )
