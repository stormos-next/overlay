# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-3.8.0.ebuild,v 1.2 2013/03/29 16:57:52 pacho Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3,3} )
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"

inherit db-use eutils flag-o-matic gnome2 python-any-r1 vala versionator virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://projects.gnome.org/evolution/"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/40" # subslot = libcamel-1.2 soname version
IUSE="api-doc-extras google +gnome-online-accounts +gtk +introspection ipv6 ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"

RDEPEND=">=dev-libs/glib-2.34:2
	>=dev-db/sqlite-3.5:=
	>=dev-libs/libgdata-0.10:=
	>=app-crypt/libsecret-0.5
	>=dev-libs/libical-0.43:=
	>=net-libs/libsoup-2.40.3:2.4
	>=dev-libs/libxml2-2
	>=sys-libs/db-4:=
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=app-crypt/gcr-3.4

	sys-libs/zlib:=
	virtual/libiconv

	gtk? ( >=x11-libs/gtk+-3.2:3 )
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.7.90
		)
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.5:2= )
"
DEPEND="${RDEPEND}
	dev-util/fix-la-relink-command
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35.5
	>=gnome-base/gnome-common-2
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2

# FIXME
#RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"

	# FIXME: Fix compilation flags crazyness
	# Touch configure.ac if doing eautoreconf
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure || die "sed failed"
}

src_configure() {
	gnome2_src_configure \
		$(use_enable api-doc-extras gtk-doc) \
		$(use_with api-doc-extras private-docs) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable introspection) \
		$(use_enable ipv6) \
		$(use_with kerberos krb5 "${EPREFIX}"/usr) \
		$(use_with ldap openldap) \
		$(use_enable vala vala-bindings) \
		$(use_enable weather) \
		$(use_enable gtk) \
		$(use_enable google) \
		--enable-nntp \
		--enable-largefile \
		--enable-smime \
		--with-libdb="${EPREFIX}"/usr \
		--disable-uoa
}

src_install() {
	# Prevent this evolution-data-server from linking to libs in the installed
	# evolution-data-server libraries by adding -L arguments for build dirs to
	# every .la file's relink_command field, forcing libtool to look there
	# first during relinking. This will mangle the .la files installed by
	# make install, but we don't care because we will be punting them anyway.
	fix-la-relink-command . || die "fix-la-relink-command failed"
	gnome2_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym /usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	export XDG_DATA_HOME="${T}"
	unset DISPLAY
	Xemake check || die "Tests failed."
}
