# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/tbb/tbb-4.1.20130116.ebuild,v 1.2 2013/02/17 00:17:37 dilfridge Exp $

EAPI=5
inherit eutils flag-o-matic multilib versionator toolchain-funcs

PV1="$(get_version_component_range 1)"
PV2="$(get_version_component_range 2)"
PV3="$(get_version_component_range 3)"
MYP="${PN}${PV1}${PV2}_${PV3}oss"

DESCRIPTION="High level abstract threading library"
HOMEPAGE="http://www.threadingbuildingblocks.org/"
SRC_URI="http://threadingbuildingblocks.org/sites/default/files/software_releases/source/${MYP}_src.tgz"
LICENSE="GPL-2-with-exceptions"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples"

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-4.0.297-underlinking.patch \
		"${FILESDIR}"/${PN}-4.1.20121003-ppc.patch
	# use fully qualified gcc compilers. do not force march/mcpu
	# not tested with icc
	# order in sed expressions is important
	sed -i \
		-e "s/g++/$(tc-getCXX)/g" \
		-e "s/gcc/$(tc-getCC)/g" \
		-e 's/-m\(arch\|cpu\)=*[[:space:]]//g' \
		-e 's/-\(m\|-\)\(64\|32\)//g' \
		-e 's/-O2/$(CXXFLAGS)/g' \
		-e "/^ASM/s/as/$(tc-getAS)/g" \
		build/*.gcc.inc || die

	find include -name \*.html -delete || die

	# pc files are for debian and fedora compatibility
	# some deps use them
	cat <<-EOF > ${PN}.pc.template
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Cflags: -I\${includedir}
	EOF
	cp ${PN}.pc.template ${PN}.pc
	cat <<-EOF >> ${PN}.pc
		Libs: -L\${libdir} -ltbb
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc.pc
	cat <<-EOF >> ${PN}malloc.pc
		Libs: -L\${libdir} -ltbbmalloc
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc_proxy.pc
	cat <<-EOF >> ${PN}malloc_proxy.pc
		Libs: -L\${libdir} -ltbbmalloc_proxy
		Libs.private: -lrt
		Requires: tbbmalloc
	EOF
	use debug || sed -i -e '/_debug/d' Makefile
}

src_compile() {
	if [[ $(tc-getCXX) == *g++ ]]; then
		comp="gcc"
	elif [[ $(tc-getCXX) == *ic*c ]]; then
		comp="icc"
	else
		die "compiler $(tc-getCXX) not supported by build system"
	fi
	emake compiler=${comp} tbb tbbmalloc
}

src_test() {
	append-cxxflags -fabi-version=4
	# avoid oversubscribing with -j1
	emake -j1 compiler=${comp} test
}

src_install(){
	local l
	for l in $(find build -name lib\*.so.\*); do
		dolib.so ${l}
		local bl=$(basename ${l})
		dosym ${bl} /usr/$(get_libdir)/${bl%.*}
	done
	doheader -r include/*

	insinto /usr/$(get_libdir)/pkgconfig
	doins *.pc

	dodoc README CHANGES doc/Release_Notes.txt
	use doc && dohtml -r doc/html/*

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples/build
		doins build/*.inc
		insinto /usr/share/doc/${PF}/examples
		doins -r examples
	fi
}
