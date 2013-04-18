# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-meta/kdepim-meta-4.10.1.ebuild,v 1.5 2013/04/02 20:51:24 ago Exp $

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="
	$(add_kdebase_dep akonadiconsole)
	$(add_kdebase_dep akregator)
	$(add_kdebase_dep blogilo)
	$(add_kdebase_dep kabcclient)
	$(add_kdebase_dep kaddressbook)
	$(add_kdebase_dep kalarm)
	$(add_kdebase_dep kdepim-icons)
	$(add_kdebase_dep kdepim-kresources)
	$(add_kdebase_dep kdepim-runtime)
	$(add_kdebase_dep kdepim-strigi-analyzer)
	$(add_kdebase_dep kjots)
	$(add_kdebase_dep kleopatra)
	$(add_kdebase_dep kmail)
	$(add_kdebase_dep knode)
	$(add_kdebase_dep knotes)
	$(add_kdebase_dep konsolekalendar)
	$(add_kdebase_dep kontact)
	$(add_kdebase_dep korganizer)
	$(add_kdebase_dep ktimetracker)
	nls? (
		$(add_kdebase_dep kde-l10n)
		$(add_kdebase_dep kdepim-l10n)
	)
"
