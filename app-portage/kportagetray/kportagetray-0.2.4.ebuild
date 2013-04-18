# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/kportagetray/kportagetray-0.2.4.ebuild,v 1.5 2011/10/29 01:06:37 abcd Exp $

EAPI=4

KDE_LINGUAS="pt_BR"
PYTHON_DEPEND="2:2.6"

EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
KDE_SCM="git"
inherit kde4-base python

DESCRIPTION="Graphical application for Portage's daily tasks"
HOMEPAGE="http://gitorious.org/kportagetray"
[[ ${PV} == 9999* ]] || SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="4"
IUSE=""

DEPEND="
	dev-python/PyQt4[svg,dbus]
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}
	app-portage/eix
	app-portage/genlop
	$(add_kdebase_dep kdesu)
	$(add_kdebase_dep knotify)
	$(add_kdebase_dep konsole)
"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
	kde4-base_src_prepare
}

pkg_postinst() {
	kde4-base_pkg_postinst
}
