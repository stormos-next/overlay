# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/ooofbtools/ooofbtools-2.12.ebuild,v 1.1 2013/03/29 10:02:39 scarabeus Exp $

EAPI=5

MY_PN="OOoFBTools"

OFFICE_EXTENSIONS=(
	"${MY_PN}.oxt"
)

inherit office-ext-r1

DESCRIPTION="Extension for converting and processing eBooks in FictionBook2 format"
HOMEPAGE="https://code.google.com/p/ooofbtools/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_PN}-${PV}.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

OFFICE_EXTENSIONS_LOCATION="${S}"
