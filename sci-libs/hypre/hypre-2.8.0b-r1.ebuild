# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/hypre/hypre-2.8.0b-r1.ebuild,v 1.9 2013/02/21 21:31:38 jlec Exp $

EAPI=4

FORTRAN_NEEDED=fortran

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Parallel matrix preconditioners library"
HOMEPAGE="http://acts.nersc.gov/hypre/"
SRC_URI="https://computation.llnl.gov/casc/hypre/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="blas doc examples fortran lapack mpi"

RDEPEND="
	sci-libs/superlu
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "${WORKDIR}"/${P}/{CHANGELOG,COPYRIGHT,README} )

S="${WORKDIR}/${P}/src"

src_prepare() {
	# link with system superlu and propagate LDFLAGS
	sed -i \
		-e 's:@LIBS@:@LIBS@ -lsuperlu:' \
		-e 's:_SHARED@:_SHARED@ $(LDFLAGS):g' \
		config/Makefile.config.in || die
	sed \
		-e '/HYPRE_ARCH/s: = :=:g' \
		-i configure || die
	tc-export CC
}

src_configure() {
	local myeconfargs+=(
		--enable-shared
		--without-superlu
		--without-strict-checking
		$(use_enable fortran)
		$(use_with mpi MPI)
	)
	if use blas; then
		myeconfargs+=(
			--with-blas-libs="$($(tc-getPKG_CONFIG) --libs-only-l blas | sed -e 's/-l//g')"
			--with-blas-lib-dirs="$($(tc-getPKG_CONFIG) --libs-only-L blas | sed -e 's/-L//g')"
		)
	else
		myeconfargs+=( --without-blas )
	fi
	if use lapack; then
		myeconfargs+=(
			--with-lapack-libs="$($(tc-getPKG_CONFIG) --libs-only-l lapack | sed -e 's/-l//g')"
			--with-lapack-lib-dirs="$($(tc-getPKG_CONFIG) --libs-only-L lapack | sed -e 's/-L//g')"
		)
	else
		myeconfargs+=( --without-lapack )
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	dolib.so hypre/lib/lib*
	insinto /usr/include/hypre
	doins -r hypre/include/*

	use doc && dodoc "${WORKDIR}"/${P}/docs/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
