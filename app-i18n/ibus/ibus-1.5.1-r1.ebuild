# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus/ibus-1.5.1-r1.ebuild,v 1.1 2013/02/09 16:22:33 naota Exp $

EAPI=4
PYTHON_DEPEND="python? 2:2.5"
VALA_MIN_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"
# Vapigen is needed for the vala binding
# Valac is needed when building from git for the engine

inherit eutils gnome2-utils multilib python vala virtualx

DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dconf deprecated +gconf gtk +gtk3 +introspection nls +python test vala +X"
REQUIRED_USE="|| ( gtk gtk3 X )
	deprecated? ( python )
	python? ( || ( deprecated ( gtk3 introspection ) ) )" #342903

COMMON_DEPEND=">=dev-libs/glib-2.26:2
	gnome-base/librsvg:2
	sys-apps/dbus[X?]
	app-text/iso-codes

	dconf? ( >=gnome-base/dconf-0.13.4 )
	gconf? ( >=gnome-base/gconf-2.12:2 )
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	X? (
		x11-libs/libX11
		x11-libs/gtk+:2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )
	nls? ( virtual/libintl )"
RDEPEND="${COMMON_DEPEND}
	python? (
		dev-python/pyxdg
		deprecated? (
			>=dev-python/dbus-python-0.83
			dev-python/pygobject:2
			dev-python/pygtk:2 )
		gtk3? (
			dev-python/pygobject:3
			x11-libs/gdk-pixbuf:2[introspection]
			x11-libs/pango[introspection]
			x11-libs/gtk+:3[introspection] )
	)"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5.8.1
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )
	vala? ( $(vala_depend) )"

# stress test in bus/ fails
# IBUS-CRITICAL **: bus_test_client_init: assertion `ibus_bus_is_connected (_bus)' failed
RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# We run "dconf update" in pkg_postinst/postrm to avoid sandbox violations
	sed -e 's/dconf update/$(NULL)/' \
		-i data/dconf/Makefile.{am,in} || die
	use python && python_clean_py-compile_files
	use vala && vala_src_prepare
	epatch "${FILESDIR}"/${P}-setup.patch \
		"${FILESDIR}"/${P}-queue-events.patch
	cp "${S}"/client/gtk2/ibusimcontext.c "${S}"/client/gtk3/ibusimcontext.c || die
}

src_configure() {
	local python_conf
	if use python; then
		# We cannot call $(PYTHON) if we haven't called python_pkg_setup
		python_conf="PYTHON=$(PYTHON)
			$(use_enable deprecated python-library)
			$(use_enable gtk3 setup)"
	else
		python_conf="--disable-python-library --disable-setup"
	fi
	econf \
		$(use_enable dconf) \
		$(use_enable introspection) \
		$(use_enable gconf) \
		$(use_enable gtk gtk2) \
		$(use_enable gtk xim) \
		$(use_enable gtk3) \
		$(use_enable gtk3 ui) \
		$(use_enable nls) \
		$(use_enable test tests) \
		$(use_enable vala) \
		$(use_enable X xim) \
		${python_conf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	insinto /etc/X11/xinit/xinput.d
	newins xinput-ibus ibus.conf

	keepdir /usr/share/ibus/{engine,icons} #289547
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	if use dconf; then
		ebegin "Updating dconf system databases"
		dconf update
		eend $?
	fi
	use gconf && gnome2_gconf_install
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	use deprecated && python_mod_optimize ${PN}
	use python && use gtk3 && python_mod_optimize /usr/share/${PN}
	gnome2_icon_cache_update

	elog "To use ibus, you should:"
	elog "1. Get input engines from sunrise overlay."
	elog "   Run \"emerge -s ibus-\" in your favorite terminal"
	elog "   for a list of packages we already have."
	elog
	elog "2. Setup ibus:"
	elog
	elog "   $ ibus-setup"
	elog
	elog "3. Set the following in your user startup scripts"
	elog "   such as .xinitrc, .xsession or .xprofile:"
	elog
	elog "   export XMODIFIERS=\"@im=ibus\""
	elog "   export GTK_IM_MODULE=\"ibus\""
	elog "   export QT_IM_MODULE=\"xim\""
	elog "   ibus-daemon -d -x"
}

pkg_postrm() {
	if use dconf; then
		ebegin "Updating dconf system databases"
		dconf update
		eend $?
	fi
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	use deprecated && python_mod_cleanup ${PN}
	use python && use gtk3 && python_mod_cleanup /usr/share/${PN}
	gnome2_icon_cache_update
}
