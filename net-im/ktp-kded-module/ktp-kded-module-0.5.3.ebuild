# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-kded-module/ktp-kded-module-0.5.3.ebuild,v 1.1 2013/04/12 07:36:55 scarabeus Exp $

EAPI=4

KDE_LINGUAS="ca cs da de el es et fi fr ga gl hu it ja km lt nb nds nl pl pt
pt_BR ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin sv uk zh_CN zh_TW"
inherit kde4-base versionator
MY_PN=${PN/kded/kded-integration}
MY_P=${MY_PN}-${PV}
KTP_PV=$(get_version_component_range 1-3)
KTP_P=${MY_PN}-${KTP_PV}

DESCRIPTION="KDE Telepathy workspace integration"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/unstable/kde-telepathy/${KTP_PV}/src/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-im/ktp-common-internals-${KTP_PV}
	>=net-libs/telepathy-qt-0.9.3
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${KTP_P}
