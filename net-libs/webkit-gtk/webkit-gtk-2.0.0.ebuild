# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-2.0.0.ebuild,v 1.4 2013/04/10 21:58:20 pacho Exp $

EAPI="5"

inherit autotools check-reqs eutils flag-o-matic gnome2-utils pax-utils toolchain-funcs versionator virtualx

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="3/25" # soname version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="aqua coverage debug +geoloc +gstreamer +introspection +jit spell +webgl"
# bugs 372493, 416331
REQUIRED_USE="introspection? ( geoloc gstreamer )"

# use sqlite, svg by default
# Aqua support in gtk3 is untested
# gtk2 is needed for plugin process support
# TODO: There's 3 acceleration backends: opengl, egl and gles2
RDEPEND="
	app-crypt/libsecret
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/harfbuzz
	media-libs/libwebp
	virtual/jpeg:=
	>=media-libs/libpng-1.4:0=
	>=x11-libs/cairo-1.10:=
	>=dev-libs/glib-2.36.0:2
	>=x11-libs/gtk+-3.6.0:3[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1:=
	>=net-libs/libsoup-2.42.0:2.4[introspection?]
	dev-db/sqlite:3=
	>=x11-libs/pango-1.32.0
	x11-libs/libXrender
	>=x11-libs/gtk+-2.24.10:2

	geoloc? ( app-misc/geoclue )
	gstreamer? (
		>=media-libs/gstreamer-1.0.3:1.0
		>=media-libs/gst-plugins-base-1.0.3:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.32.0 )
	spell? ( >=app-text/enchant-0.22:= )
	webgl? (
		virtual/opengl
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"
# paxctl needed for bug #407085
DEPEND="${RDEPEND}
	dev-lang/perl
	=dev-lang/python-2*
	|| ( virtual/rubygems[ruby_targets_ruby19]
	     virtual/rubygems[ruby_targets_ruby18] )
	>=app-accessibility/at-spi2-core-2.5.3
	>=dev-util/gtk-doc-am-1.10
	dev-util/gperf
	sys-devel/bison
	>=sys-devel/flex-2.5.33
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.0 )
	sys-devel/gettext
	>=sys-devel/make-3.82-r4
	virtual/pkgconfig

	introspection? ( jit? ( sys-apps/paxctl ) )
	test? (
		x11-themes/hicolor-icon-theme
		jit? ( sys-apps/paxctl ) )
"
# Need real bison, not yacc

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" ; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
		check-reqs_pkg_pretend
	fi

	if ! test-flag-CXX -std=c++11; then
		die "You need at least GCC 4.7.x or Clang >= 3.0 for C++11-specific compiler flags"
	fi
}

pkg_setup() {
	# Check whether any of the debugging flags is enabled
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" ; then
		if is-flagq "-ggdb" && [[ ${WEBKIT_GTK_GGDB} != "yes" ]]; then
			replace-flags -ggdb -g
			ewarn "Replacing \"-ggdb\" with \"-g\" in your CFLAGS."
			ewarn "Building ${PN} with \"-ggdb\" produces binaries which are too"
			ewarn "large for current binutils releases (bug #432784) and has very"
			ewarn "high temporary build space and memory requirements."
			ewarn "If you really want to build ${PN} with \"-ggdb\", add"
			ewarn "WEBKIT_GTK_GGDB=yes"
			ewarn "to your make.conf file."
		fi
		einfo "You need to have at least 18GB of temporary build space available"
		einfo "to build ${PN} with debugging CFLAGS. Note that it might still"
		einfo "not be enough, as the total space requirements depend on the flags"
		einfo "(-ggdb vs -g1) and enabled features."
		check-reqs_pkg_setup
	fi
}

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.6.1-darwin-quartz.patch

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/Source/autotools/SetupCompilerFlags.m4 || die

	# Build-time segfaults under PaX with USE="introspection jit", bug #404215
	if use introspection && use jit; then
		epatch "${FILESDIR}/${PN}-1.6.3-paxctl-introspection.patch"
		cp "${FILESDIR}/gir-paxctl-lt-wrapper" "${S}/" || die
	fi

	# We need to reset some variables to prevent permissions problems and failures
	# like https://bugs.webkit.org/show_bug.cgi?id=35471 and bug #323669
	gnome2_environment_reset

	# XXX: failing tests
	# https://bugs.webkit.org/show_bug.cgi?id=50744
	# testkeyevents is interactive
	# mimehandling test sometimes fails under Xvfb (works fine manually)
	# datasource test needs a network connection and intermittently fails with icedtea-web
	# webplugindatabase intermittently fails with icedtea-web
	sed -e '/Programs\/unittests\/testwebinspector/ d' \
		-e '/Programs\/unittests\/testkeyevents/ d' \
		-e '/Programs\/unittests\/testmimehandling/ d' \
		-e '/Programs\/unittests\/testwebdatasource/ d' \
		-e '/Programs\/unittests\/testwebplugindatabase/ d' \
		-i Source/WebKit/gtk/GNUmakefile.am || die

	if ! use gstreamer; then
		# webkit2's TestWebKitWebView requires <video> support
		sed -e '/Programs\/WebKit2APITests\/TestWebKitWebView/ d' \
			-i Source/WebKit2/UIProcess/API/gtk/tests/GNUmakefile.am || die
	fi
	# garbage collection test fails intermittently if icedtea-web is installed
	epatch "${FILESDIR}/${PN}-1.7.90-test_garbage_collection.patch"

	# occasional test failure due to additional Xvfb process spawned
	# TODO epatch "${FILESDIR}/${PN}-1.8.1-tests-xvfb.patch"

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	epatch "${FILESDIR}/${PN}-1.11.90-gtk-docize-fix.patch"

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf

	# Ugly hack of a workaround for bizarre paludis behavior, bug #406117
	# http://paludis.exherbo.org/trac/ticket/1230
	sed -e '/  --\(en\|dis\)able-dependency-tracking/ d' -i configure || die
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co.
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	local myconf

	# XXX: Check Web Audio support
	# XXX: dependency-tracking is required so parallel builds won't fail
	# XXX: There's 3 acceleration backends: opengl, egl and gles2
	#      should somehow let user select between them?
	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable geoloc geolocation)
		$(use_enable spell spellcheck)
		$(use_enable introspection)
		$(use_enable gstreamer video)
		$(use_enable jit)
		$(use_enable webgl)
		--disable-egl
		--disable-gles2
		--with-gtk=3.0
		--enable-accelerated-compositing
		--enable-dependency-tracking
		--disable-gtk-doc
		PYTHON=$(type -P python2)
		"$(usex aqua "--with-font-backend=pango --with-target=quartz" "")
		# Aqua support in gtk3 is untested

	if has_version "virtual/rubygems[ruby_targets_ruby19]"; then
		myconf="${myconf} RUBY=$(type -P ruby19)"
	else
		myconf="${myconf} RUBY=$(type -P ruby18)"
	fi

	econf ${myconf}
}

src_compile() {
	# Avoid parallel make failure with -j9
	emake DerivedSources/WebCore/JSNode.h
	default
}

src_test() {
	# Tests expect an out-of-source build in WebKitBuild
	ln -s . WebKitBuild || die "ln failed"

	# Prevents test failures on PaX systems
	use jit && pax-mark m $(list-paxables Programs/*[Tt]ests/*) \
		Programs/unittests/.libs/test*
	unset DISPLAY
	# Tests need virtualx, bug #294691, bug #310695
	# Parallel tests sometimes fail
	Xemake -j1 check
}

src_install() {
	default

	newdoc Source/WebKit/gtk/ChangeLog ChangeLog.gtk
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	prune_libtool_files

	# Prevents crashes on PaX systems
	use jit && pax-mark m "${ED}usr/bin/jsc-3"
}
