# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kuser/kuser-4.10.1.ebuild,v 1.5 2013/04/02 20:51:44 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdeadmin"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="KDE application that helps you manage system users"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
"
# notify is needed for dialogs
RDEPEND="${DEPEND}
	$(add_kdebase_dep knotify)
"
