# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/antlr/antlr-2.7.7-r1.ebuild,v 1.3 2013/02/05 06:54:43 zerochaos Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"

inherit base java-pkg-2 mono distutils multilib

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr2.org/"
SRC_URI="http://www.antlr2.org/download/${P}.tar.gz"

LICENSE="ANTLR"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc debug examples mono +cxx +java python script source"

# TODO do we actually need jdk at runtime?
RDEPEND=">=virtual/jdk-1.3
	mono? ( dev-lang/mono )"
DEPEND="${RDEPEND}
	script? ( !dev-util/pccts )
	source? ( app-arch/zip )"

PATCHES=( "${FILESDIR}/2.7.7-gcc-4.3.patch" "${FILESDIR}/2.7.7-gcc-4.4.patch" "${FILESDIR}/2.7.7-makefixes.patch" )

pkg_setup() {
	java-pkg-2_pkg_setup

	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	base_src_prepare
}

src_configure() {
	# don't ask why, but this is needed for stuff to get built properly
	# across the various JDKs
	JAVACFLAGS="+ ${JAVACFLAGS}"

	# mcs for https://bugs.gentoo.org/show_bug.cgi?id=172104
	CSHARPC="mcs" econf $(use_enable java) \
		$(use_enable python) \
		$(use_enable mono csharp) \
		$(use_enable debug) \
		$(use_enable examples) \
		$(use_enable cxx) \
		--enable-verbose
}

src_compile() {
	emake || die "compile failed"

	sed -e "s|@prefix@|/usr/|" \
		-e 's|@exec_prefix@|${prefix}|' \
		-e "s|@libdir@|\$\{exec_prefix\}/$(get_libdir)/antlr|" \
		-e 's|@libs@|-r:\$\{libdir\}/antlr.astframe.dll -r:\$\{libdir\}/antlr.runtime.dll|' \
		-e "s|@VERSION@|${PV}|" \
		"${FILESDIR}"/antlr.pc.in > "${S}"/antlr.pc
}

src_install() {
	exeinto /usr/bin
	doexe "${S}"/scripts/antlr-config

	if use cxx ; then
		cd "${S}"/lib/cpp
		einstall || die "failed to install C++ files"
	fi

	if use java ; then
		java-pkg_dojar "${S}"/antlr/antlr.jar

		use script && java-pkg_dolauncher antlr --main antlr.Tool

		use source && java-pkg_dosrc "${S}"/antlr
		use doc && java-pkg_dohtml -r "${S}"/doc/*
	fi

	if use mono ; then
		cd "${S}"/lib

		dodir /usr/$(get_libdir)/antlr/
		insinto /usr/$(get_libdir)/antlr/

		doins antlr.astframe.dll
		doins antlr.runtime.dll

		insinto /usr/$(get_libdir)/pkgconfig
		doins "${S}"/antlr.pc
	fi

	if use python ; then
		cd "${S}"/lib/python
		distutils_src_install
	fi

	if use examples ; then
		find "${S}"/examples -iname Makefile\* -exec rm \{\} \;

		dodir /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples

		use cxx && doins -r "${S}"/examples/cpp
		use java && doins -r "${S}"/examples/java
		use mono && doins -r "${S}"/examples/csharp
		use python && doins -r "${S}"/examples/python
	fi

	newdoc "${S}"/README.txt README || die
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
