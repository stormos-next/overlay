# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/get_flash_videos/get_flash_videos-1.24.ebuild,v 1.4 2011/07/29 22:16:43 zmedico Exp $

EAPI=2
inherit perl-module

MY_PN="App-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="http://code.google.com/p/get-flash-videos/"
SRC_URI="http://get-flash-videos.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE="test"

RDEPEND="dev-perl/WWW-Mechanize
	perl-core/Module-CoreList
	dev-perl/HTML-TokeParser-Simple"
DEPEND="${RDEPEND}
	dev-perl/UNIVERSAL-require
	test? ( media-video/rtmpdump
		dev-perl/Tie-IxHash
		dev-perl/XML-Simple
		dev-perl/Crypt-Rijndael
		dev-perl/Data-AMF
		perl-core/IO-Compress )"

SRC_TEST="do"

S="${WORKDIR}/${MY_P}"
SRC_TEST="do"
myinst="DESTDIR=${D}"

pkg_postinst() {
	elog "Downloading videos from RTMP server requires the following packages :"
	elog "	media-video/rtmpdump"
	elog "	dev-perl/Tie-IxHash"
	elog "Others optional dependencies :"
	elog "	dev-perl/XML-Simple"
	elog "	dev-perl/Crypt-Rijndael"
	elog "	dev-perl/Data-AMF"
	elog "	perl-core/IO-Compress"
}
