# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ceres-solver/ceres-solver-1.4.0.ebuild,v 1.4 2013/03/04 18:28:26 bicatali Exp $

EAPI=4

inherit cmake-utils eutils multilib toolchain-funcs

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="https://code.google.com/p/ceres-solver/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples gflags metis openmp protobuf +schur +sparse static-libs test"
REQUIRED_USE="test? ( gflags )"

RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/glog[gflags?]
	protobuf? ( dev-libs/protobuf )
	sparse? (
		sci-libs/amd
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod[metis?]
		sci-libs/colamd
		sci-libs/cxsparse
		virtual/blas
		virtual/lapack )"
DEPEND="${RDEPEND}
	sparse? ( virtual/pkgconfig )
	doc? (
		dev-python/pygments
		dev-tex/minted
		dev-texlive/texlive-science
		virtual/latex-base )"

src_prepare() {
	# prefix love
	# disable blas/lapack forced library names
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e '/FIND_LIBRARY(BLAS_LIB NAMES blas)/d' \
		-e '/FIND_LIBRARY(LAPACK_LIB NAMES lapack)/d' \
		-e 's/EXISTS ${BLAS_LIB}/BLAS_LIB/g' \
		-e 's/EXISTS ${LAPACK_LIB}/LAPACK_LIB/g' \
		CMakeLists.txt || die

	# remove downloading minted.sty
	sed -i \
		-e '/minted/d' \
		-e '/SHOW_PROGRES/d' \
		-e "s:share/ceres/docs:share/doc/${PF}:" \
		docs/CMakeLists.txt || die

	epatch \
		"${FILESDIR}"/${P}-test-no-suitesparse.patch \
		"${FILESDIR}"/${P}-respect-libdir.patch
}

src_configure() {
	local blibs llibs
	if use sparse; then
		blibs=$($(tc-getPKG_CONFIG) --libs blas)
		llibs=$($(tc-getPKG_CONFIG) --libs lapack)
	fi
	local mycmakeargs=(
		-DBLAS_LIB="${blibs}"
		-DLAPACK_LIB="${llibs}"
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use gflags GFLAGS)
		$(cmake-utils_use openmp OPENMP)
		$(cmake-utils_use protobuf PROTOBUF)
		$(cmake-utils_use schur SCHUR_SPECIALIZATIONS)
		$(cmake-utils_use sparse CXSPARSE)
		$(cmake-utils_use sparse SUITESPARSE)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README VERSION

	use static-libs || rm "${ED}"/usr/$(get_libdir)/libceres.a
	dosym libceres_shared.so /usr/$(get_libdir)/libceres.so

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
