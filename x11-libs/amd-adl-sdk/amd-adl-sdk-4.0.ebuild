# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/amd-adl-sdk/amd-adl-sdk-4.0.ebuild,v 1.3 2013/02/25 13:30:52 ago Exp $

EAPI="4"

DESCRIPTION="API to access display driver functionality for ATI graphics cards"
HOMEPAGE="http://developer.amd.com/sdks/adlsdk/"
SRC_URI="http://download2-developer.amd.com/amd/GPU/zip/ADL_SDK_${PV}.zip"

LICENSE="AMD-ADL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND=""
RDEPEND="${DEPEND}
	x11-drivers/ati-drivers
"
DEPEND="${DEPEND}
	app-arch/unzip
"

RESTRICT="mirror"

S="${WORKDIR}"

src_install() {
	use doc && dodoc -r "Public-Documents"/* "adlutil/ADLUTIL User Guide.doc"
	use examples && dodoc -r "Sample" "Sample-Managed"

	insinto "/usr/include/ADL"
	doins include/*
}
