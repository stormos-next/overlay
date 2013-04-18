# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kteatime/kteatime-4.10.1.ebuild,v 1.6 2013/04/02 20:51:21 ago Exp $

EAPI=5

if [[ ${PV} == *9999 ]]; then
	eclass="kde4-base"
else
	eclass="kde4-meta"
	KMNAME="kdetoys"
fi
KDE_HANDBOOK="optional"
inherit ${eclass}

DESCRIPTION="KDE timer for making a fine cup of tea"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
