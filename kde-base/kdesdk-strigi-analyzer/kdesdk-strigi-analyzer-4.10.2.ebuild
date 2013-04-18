# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-strigi-analyzer/kdesdk-strigi-analyzer-4.10.2.ebuild,v 1.1 2013/04/06 00:04:31 dilfridge Exp $

EAPI=5

if [[ ${PV} == *9999 ]]; then
	eclass="kde4-base"
	KMNAME="kdesdk-strigi-analyzers"
else
	eclass="kde4-meta"
	KMNAME="kdesdk"
	KMMODULE="kdesdk-strigi-analyzers"
fi
inherit ${eclass}

DESCRIPTION="kdesdk: strigi plugins"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-misc/strigi
"
RDEPEND="${DEPEND}"
