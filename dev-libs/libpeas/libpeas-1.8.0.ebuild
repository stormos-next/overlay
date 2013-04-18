# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpeas/libpeas-1.8.0.ebuild,v 1.1 2013/03/28 16:33:33 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit eutils gnome2 multilib python-r1 virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="http://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gjs +gtk glade +python seed"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"

RDEPEND=">=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-0.10.1
	gjs? ( >=dev-libs/gjs-1.31.11 )
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0.0:3[${PYTHON_USEDEP}] )
	seed? ( >=dev-libs/seed-2.91.91 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17"

if_use_python_python_foreach_impl() {
	if use python; then
		python_foreach_impl run_in_build_dir "$@"
	else
		"$@"
	fi
}

src_prepare() {
	use python && python_copy_sources
	if_use_python_python_foreach_impl gnome2_src_prepare
}

src_configure() {
	G2CONF="${G2CONF}
		$(use_enable gjs)
		$(use_enable glade glade-catalog)
		$(use_enable gtk)
		$(use_enable seed)
		--disable-deprecation
		--disable-static"
	# Wtf, --disable-gcov, --enable-gcov=no, --enable-gcov, all enable gcov
	# What do we do about gdb, valgrind, gcov, etc?

	configuration() {
		local G2CONF="${G2CONF}"
		[[ ${EPYTHON} == python2* ]] && G2CONF+=" --enable-python2 --disable-python3 PYTHON2_CONFIG=/usr/bin/python-config-${EPYTHON#python}"
		[[ ${EPYTHON} == python3* ]] && G2CONF+=" --enable-python3 --disable-python2 PYTHON3_CONFIG=/usr/bin/python-config-${EPYTHON#python}"
		gnome2_src_configure
	}

	if use python; then
		python_foreach_impl run_in_build_dir configuration
	else
		gnome2_src_configure
	fi
}

src_compile() {
	if_use_python_python_foreach_impl gnome2_src_compile
}

src_install() {
	if_use_python_python_foreach_impl gnome2_src_install
}

src_test() {
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	if_use_python_python_foreach_impl Xemake check
}
