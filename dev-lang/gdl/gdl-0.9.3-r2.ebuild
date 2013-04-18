# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gdl/gdl-0.9.3-r2.ebuild,v 1.1 2013/01/10 22:40:35 bicatali Exp $

EAPI=4

WX_GTK_VER="2.8"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"

inherit cmake-utils eutils wxwidgets python toolchain-funcs virtualx

DESCRIPTION="Interactive Data Language compatible incremental compiler"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fftw grib gshhs hdf hdf5 imagemagick netcdf openmp proj postscript python
	static-libs udunits wxwidgets"

# very buggy tests
RESTRICT=test

RDEPEND="
	sci-libs/gsl
	sci-libs/plplot
	sys-libs/ncurses
	sys-libs/readline
	sys-libs/zlib
	x11-libs/libX11
	fftw? ( >=sci-libs/fftw-3 )
	grib? ( sci-libs/grib_api )
	gshhs? ( sci-geosciences/gshhs-data sci-geosciences/gshhs )
	hdf? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5 )
	imagemagick? ( media-gfx/imagemagick )
	netcdf? ( || ( >=sci-libs/netcdf-cxx-4.2-r1 sci-libs/netcdf[cxx] ) )
	proj? ( sci-libs/proj )
	postscript? ( dev-libs/pslib )
	python? ( dev-python/numpy )
	udunits? ( sci-libs/udunits )
	wxwidgets? ( x11-libs/wxGTK:2.8[X,-odbc] )"

DEPEND="${RDEPEND}
	>=dev-java/antlr-2.7.7-r5:0[cxx,java,script]
	virtual/pkgconfig"

pkg_setup() {
	use wxwidgets && wxwidgets_pkg_setup
	use python && python_pkg_setup
	use openmp && [[ $(tc-getCXX)$ == *g++* ]] && ! tc-has-openmp && \
		die "You have openmp enabled but your current g++ does not support it"
}

src_prepare() {
	use hdf5 && has_version sci-libs/hdf5[mpi] && export CXX=mpicxx

	epatch "${FILESDIR}"/0.9.2-{antlr,proj4,include,tests,semaphore}.patch
	epatch "${FILESDIR}"/0.9.3-{sstream,netcdf-cxx}.patch
	# make sure antlr includes are from system and rebuild the sources with it
	# https://sourceforge.net/tracker/?func=detail&atid=618685&aid=3465878&group_id=97659

	rm -r src/antlr || die
	einfo "Regenerate grammar"
	pushd src > /dev/null
	local i
	for i in *.g; do antlr ${i} || die ; done
	popd > /dev/null

	# gentoo: use proj instead of libproj4 (libproj4 last update: 2004)
	sed -i \
		-e 's:proj4:proj:' \
		-e 's:lib_proj\.h:proj_api\.h:g' \
		CMakeModules/FindLibproj4.cmake src/math_utl.hpp || die

	# gentoo: avoid install files in datadir directory
	sed -i \
		-e '/AUTHORS/d' \
		CMakeLists.txt || die

	if use python; then
		local abi
		for abi in ${PYTHON_ABIS}; do
			mkdir "${S}"-${abi}
		done
	fi
	if has_version sci-libs/netcdf-cxx; then
		sed -i \
			-e 's/netcdfcpp.h/netcdf/g' \
			CMakeLists.txt src/ncdf_var_cl.cpp \
			src/ncdf_cl.hpp src/ncdf_{att,dim}_cl.cpp || die
	fi
}

src_configure() {
	# MPI is still very buggy
	# x11=off does not compile
	local mycmakeargs=(
		-DMPICH=OFF
		-DBUNDLED_ANTLR=OFF
		-DX11=ON
		$(cmake-utils_use fftw)
		$(cmake-utils_use grib)
		$(cmake-utils_use gshhs)
		$(cmake-utils_use hdf)
		$(cmake-utils_use hdf5)
		$(cmake-utils_use imagemagick MAGICK)
		$(cmake-utils_use netcdf)
		$(cmake-utils_use openmp)
		$(cmake-utils_use proj LIBPROJ4)
		$(cmake-utils_use postscript PSLIB)
		$(cmake-utils_use udunits)
		$(cmake-utils_use wxwidgets)
	)
	configuration() {
		mycmakeargs+=( $@ )
		BUILD_DIR="${BUILDDIR:-${S}_build}" cmake-utils_src_configure
	}
	configuration -DPYTHON_MODULE=OFF -DPYTHON=OFF
	use python && python_execute_function -s \
		configuration -DPYTHON_MODULE=ON -DPYTHON=ON
}

src_compile() {
	BUILD_DIR="${S}_build" cmake-utils_src_compile
	use python && VERBOSE=1 python_src_compile
}

src_test() {
	# upstream does not include tests if python module is on
	# there is check target instead of the ctest to define some LDPATH
	use python || Xemake -j1 -C ${BUILD_DIR} check
}

src_install() {
	BUILD_DIR="${S}_build" cmake-utils_src_install
	if use python; then
		installation() {
			exeinto $(python_get_sitedir)
			newexe "${S}"-${PYTHON_ABI}/src/libgdl.so GDL.so
		}
		python_execute_function -s installation
		dodoc PYTHON.txt
	fi
	echo "GDL_PATH=\"+${EROOT}/usr/share/gnudatalanguage\"" > 50gdl
	doenvd 50gdl
}
