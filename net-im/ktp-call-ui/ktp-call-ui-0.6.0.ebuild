# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-call-ui/ktp-call-ui-0.6.0.ebuild,v 1.2 2013/04/12 09:11:45 scarabeus Exp $

EAPI=4

KDE_LINGUAS="bg ca cs da de en_GB eo es et fi fr ga gl hu it ja km lt mai nds nl
pl pt pt_BR ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin sv th tr ug uk
zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy audio/video conferencing ui"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="debug v4l"

DEPEND="
	>=media-libs/qt-gstreamer-0.10.2
	>=net-im/ktp-common-internals-${PV}
	<net-libs/telepathy-farstream-0.6
	>=net-libs/telepathy-qt-0.9.3[farstream]
"
RDEPEND="${DEPEND}
	|| (
		>=net-im/ktp-contact-applet-${PV}
		>=net-im/ktp-contact-list-${PV}
		>=net-im/ktp-text-ui-${PV}
	)
	v4l? ( media-plugins/gst-plugins-v4l2:0.10 )
"
