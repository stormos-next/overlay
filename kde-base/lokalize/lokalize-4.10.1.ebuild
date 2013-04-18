# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lokalize/lokalize-4.10.1.ebuild,v 1.5 2013/04/02 20:51:31 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
if [[ ${PV} == *9999 ]]; then
	eclass="kde4-base"
else
	eclass="kde4-meta"
	KMNAME="kdesdk"
fi
PYTHON_DEPEND="2"
inherit python ${eclass}

DESCRIPTION="KDE4 translation tool"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug semantic-desktop"

DEPEND="
	>=app-text/hunspell-1.2.8
	>=dev-qt/qtsql-4.5.0:4[sqlite]
	semantic-desktop? ( >=dev-libs/soprano-2.9.0 )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdesdk-strigi-analyzer)
	$(add_kdebase_dep krosspython)
	$(add_kdebase_dep pykde4)
"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	${eclass}_pkg_setup
}

src_install() {
	${eclass}_src_install
	python_convert_shebangs -q -r $(python_get_version) "${ED}/usr/share/apps/${PN}"
}

pkg_postinst() {
	${eclass}_pkg_postinst

	if ! has_version dev-vcs/subversion ; then
		elog "To be able to autofetch KDE translations in new project wizard, install dev-vcs/subversion."
	fi
}
