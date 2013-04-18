# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-misc/kdesdk-misc-4.10.2.ebuild,v 1.1 2013/04/06 00:04:33 dilfridge Exp $

EAPI=5

if [[ ${PV} == *9999 ]]; then
	KMNAME="kde-dev-utils"
else
	KMEXTRA="poxml/"
	KMNAME="kdesdk"
	KMMODULE="kde-dev-utils"
fi
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="KDE miscellaneous SDK tools"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug extras"

KMEXTRA+="
	${KMMODULE}/kmtrace/
	${KMMODULE}/kpartloader/
	${KMMODULE}/kprofilemethod/
"

DEPEND="
	extras? ( >=dev-java/antlr-2.7.7:0[cxx,java,script] )
"
RDEPEND="${DEPEND}"

add_blocker poxml '<4.10.1'

# java deps on anltr cant be properly explained to cmake deps
# needs to be run in one thread
MAKEOPTS+=" -j1"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with extras Antlr2)
	)

	kde4-meta_src_configure
}
