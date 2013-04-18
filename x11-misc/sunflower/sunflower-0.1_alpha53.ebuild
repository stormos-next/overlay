# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sunflower/sunflower-0.1_alpha53.ebuild,v 1.1 2013/02/05 13:12:38 hasufell Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PLOCALES="bg cs de es hu pl ru uk_UA"
inherit eutils fdo-mime gnome2-utils l10n python-r1

MY_PV="${PV%_alpha*}a-${PV#*_alpha}"
MY_PN="Sunflower"
DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="http://code.google.com/p/sunflower-fm"
SRC_URI="http://sunflower-fm.googlecode.com/files/${MY_PN}-${MY_PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.15.0
	>=dev-python/notify-python-0.1
	virtual/python-argparse[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	find "${S}" -name "*.py[co]" -delete || die
	find "${S}"/translations -name "*.po" -delete || die

	sed -i \
		-e '/^application_file/s/os.path.dirname(sys.argv\[0\])/os.getcwd()/' \
		${MY_PN}.py || die
}

src_install() {
	touch __init__.py || die
	installme() {
		# install modules
		python_moduleinto ${PN}
		python_domodule images application ${MY_PN}.py \
			AUTHORS CHANGES COPYING DEPENDS TODO __init__.py

		# generate and install startup scripts
		sed \
			-e "s#@SITEDIR@#$(python_get_sitedir)/${PN}#" \
			"${FILESDIR}"/${PN} > "${T}"/${PN} || die
		python_doscript "${T}"/${PN}
	}

	# install for all enabled implementations
	python_foreach_impl installme

	installlocale() { insinto /usr/share/locale ; doins -r "${S}"/translations/${1} ;}
	l10n_for_each_locale_do installlocale

	newicon -s 64 images/${PN}_64.png ${PN}.png
	doicon -s scalable images/${PN}.svg
	newmenu ${MY_PN}.desktop ${PN}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	# TODO: better description
	elog "optional dependencies:"
	elog "  dev-python/libgnome-python"
	elog "  media-libs/mutagen"
	elog "  x11-libs/vte:0[python] (terminal support)"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
