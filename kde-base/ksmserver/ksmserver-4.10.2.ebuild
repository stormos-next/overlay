# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-4.10.2.ebuild,v 1.1 2013/04/06 00:04:52 dilfridge Exp $

EAPI=5

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kcminit)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep solid)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kcminit/main.h
	libs/kdm/kgreeterplugin.h
	kcheckpass/
	libs/kephal/
	libs/kworkspace/
	solid/
"

KMLOADLIBS="libkworkspace"

PATCHES=( "${FILESDIR}/${PN}-4.10.1-noplasmalock.patch" )
