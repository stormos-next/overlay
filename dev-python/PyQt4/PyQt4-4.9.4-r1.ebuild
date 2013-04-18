# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt4/PyQt4-4.9.4-r1.ebuild,v 1.4 2013/03/03 00:36:24 hwoarang Exp $

EAPI=4

PYTHON_DEPEND="*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython *-pypy-*"

inherit eutils toolchain-funcs qt4-r2 python

# Minimal supported version of Qt.
QT_VER="4.7.2"

DESCRIPTION="Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/ http://pypi.python.org/pypi/PyQt"

if [[ ${PV} == *_pre* ]]; then
	MY_P="PyQt-x11-gpl-snapshot-${PV%_pre*}-${REVISION}"
	SRC_URI="http://www.gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"
else
	MY_P="PyQt-x11-gpl-${PV}"
	SRC_URI="http://www.riverbankcomputing.com/static/Downloads/${PN}/${MY_P}.tar.gz"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="X assistant dbus debug declarative doc examples kde multimedia opengl phonon sql svg webkit xmlpatterns"

REQUIRED_USE="
	assistant? ( X )
	declarative? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	sql? ( X )
	svg? ( X )
	webkit? ( X )
"

RDEPEND="
	>=dev-python/sip-4.13.3
	>=dev-qt/qtcore-${QT_VER}:4
	>=dev-qt/qtscript-${QT_VER}:4
	X? (
		>=dev-qt/qtgui-${QT_VER}:4[dbus?]
		>=dev-qt/qttest-${QT_VER}:4
	)
	assistant? ( >=dev-qt/qthelp-${QT_VER}:4 )
	dbus? (
		>=dev-python/dbus-python-0.80
		>=dev-qt/qtdbus-${QT_VER}:4
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_VER}:4 )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_VER}:4 )
	opengl? (
		>=dev-qt/qtopengl-${QT_VER}:4
		|| ( >=dev-qt/qtopengl-4.8.0:4 <dev-qt/qtopengl-4.8.0:4[-egl] )
	)
	phonon? (
		!kde? ( || ( >=dev-qt/qtphonon-${QT_VER}:4 media-libs/phonon ) )
		kde? ( media-libs/phonon )
	)
	sql? ( >=dev-qt/qtsql-${QT_VER}:4 )
	svg? ( >=dev-qt/qtsvg-${QT_VER}:4 )
	webkit? ( >=dev-qt/qtwebkit-${QT_VER}:4 )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_VER}:4 )
"
DEPEND="${RDEPEND}
	dbus? ( virtual/pkgconfig )
"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-4.7.2-configure.py.patch"
	"${FILESDIR}/${P}-pyuic-custom-widgets.patch"
)

PYTHON_VERSIONED_EXECUTABLES=("/usr/bin/pyuic4")

src_prepare() {
	if ! use dbus; then
		sed -e 's/^\([[:blank:]]\+\)check_dbus()/\1pass/' -i configure.py || die
	fi

	# Support qreal for arm architecture (bug #322349).
	use arm && epatch "${FILESDIR}/${PN}-4.7.3-qreal_float_support.patch"

	qt4-r2_src_prepare

	# Use proper include directory.
	sed -e "s:/usr/include:${EPREFIX}/usr/include:g" -i configure.py || die

	python_copy_sources

	preparation() {
		if [[ $(python_get_version -l --major) == 3 ]]; then
			rm -fr pyuic/uic/port_v2
		else
			rm -fr pyuic/uic/port_v3
		fi
	}
	python_execute_function -s preparation
}

pyqt4_use_enable() {
	use $1 && echo "--enable=${2:-$1}"
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			--confirm-license
			--bindir="${EPREFIX}/usr/bin"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			--assume-shared
			--no-timestamp
			--qsci-api
			$(use debug && echo --debug)
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtScript
			--enable=QtXml
			$(pyqt4_use_enable X QtGui)
			$(pyqt4_use_enable X QtDesigner) $(use X || echo --no-designer-plugin)
			$(pyqt4_use_enable X QtScriptTools)
			$(pyqt4_use_enable X QtTest)
			$(pyqt4_use_enable assistant QtHelp)
			$(pyqt4_use_enable dbus QtDBus)
			$(pyqt4_use_enable declarative QtDeclarative)
			$(pyqt4_use_enable multimedia QtMultimedia)
			$(pyqt4_use_enable opengl QtOpenGL)
			$(pyqt4_use_enable phonon)
			$(pyqt4_use_enable sql QtSql)
			$(pyqt4_use_enable svg QtSvg)
			$(pyqt4_use_enable webkit QtWebKit)
			$(pyqt4_use_enable xmlpatterns QtXmlPatterns)
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			CFLAGS="${CFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			LFLAGS="${LDFLAGS}")
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		local mod
		for mod in QtCore \
				$(use X && echo QtDesigner QtGui) \
				$(use dbus && echo QtDBus) \
				$(use declarative && echo QtDeclarative) \
				$(use opengl && echo QtOpenGL); do
			# Run eqmake4 inside the qpy subdirectories to respect
			# CC, CXX, CFLAGS, CXXFLAGS, LDFLAGS and avoid stripping.
			pushd qpy/${mod} > /dev/null || return 1
			eqmake4 $(ls w_qpy*.pro)
			popd > /dev/null || return 1

			# Fix insecure runpaths.
			sed -e "/^LFLAGS[[:space:]]*=/s:-Wl,-rpath,${BUILDDIR}/qpy/${mod}::" \
				-i ${mod}/Makefile || die "Failed to fix rpath for ${mod}"
		done

		# Avoid stripping of libpythonplugin.so.
		if use X; then
			pushd designer > /dev/null || return 1
			eqmake4 python.pro
			popd > /dev/null || return 1
		fi
	}
	python_execute_function -s configuration
}

src_install() {
	installation() {
		# INSTALL_ROOT is used by designer/Makefile, other Makefiles use DESTDIR.
		emake DESTDIR="${T}/images/${PYTHON_ABI}" INSTALL_ROOT="${T}/images/${PYTHON_ABI}" install
	}
	python_execute_function -s installation
	python_merge_intermediate_installation_images "${T}/images"

	dodoc NEWS THANKS

	if use doc; then
		dohtml -r doc/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_mod_optimize PyQt4

	ewarn "When updating dev-python/PyQt4, you usually need to rebuild packages that depend on it,"
	ewarn "such as dev-python/qscintilla-python and kde-base/pykde4. If you have app-portage/gentoolkit"
	ewarn "installed, you can find these packages with \`equery d dev-python/PyQt4\`."
}

pkg_postrm() {
	python_mod_cleanup PyQt4
}
