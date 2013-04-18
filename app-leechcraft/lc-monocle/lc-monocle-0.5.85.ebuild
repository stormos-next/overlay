# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-monocle/lc-monocle-0.5.85.ebuild,v 1.1 2013/03/08 22:02:32 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Monocle, the modular document viewer for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+djvu debug +fb2 +pdf"

DEPEND="~app-leechcraft/lc-core-${PV}
	pdf? ( app-text/poppler[qt4] )
	djvu? ( app-text/djvu )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable djvu MONOCLE_SEEN)
		$(cmake-utils_use_enable fb2 MONOCLE_FXB)
		$(cmake-utils_use_enable pdf MONOCLE_PDF)"

	cmake-utils_src_configure
}
