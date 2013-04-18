# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-6.0.2-r1.ebuild,v 1.1 2013/03/05 12:56:06 jlec Exp $

EAPI=5

inherit eutils qt4-r2

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV/_/-}/${MY_P}.tar.bz2"

LICENSE="qwt mathml? ( LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1 )"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
SLOT="6"
IUSE="doc examples mathml static-libs svg"

DEPEND="
	dev-qt/qtgui:4
	doc? ( !<media-libs/coin-3.1.3[doc] )
	svg? ( dev-qt/qtsvg:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS="CHANGES README"

src_prepare() {
	cat > qwtconfig.pri <<-EOF
		QWT_INSTALL_LIBS = "${EPREFIX}/usr/$(get_libdir)"
		QWT_INSTALL_HEADERS = "${EPREFIX}/usr/include/qwt6"
		QWT_INSTALL_DOCS = "${EPREFIX}/usr/share/doc/${PF}"
		QWT_CONFIG += QwtDll QwtPlot QwtWidgets QwtDesigner
		VERSION = ${PV/_*}
		QWT_VERSION = ${PV/_*}
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/share/qt4/mkspecs/features"
	EOF
	if use mathml; then
		cat >> qwtconfig.pri <<-EOF
			QWT_CONFIG += QwtMathML
		EOF
	fi
	cat > qwtbuild.pri <<-EOF
		QWT_CONFIG += qt warn_on thread release no_keywords
	EOF

	sed \
		-e 's/target doc/target/' \
		-i src/src.pro || die

	# Renaming lib to libqwt6.so to enable slotting
	sed \
		-e "/^TARGET/s:(qwt):(qwt6):g" \
		-i src/src.pro || die
	sed \
		-e '/qwtAddLibrary/s:(qwt):(qwt6):g' \
		-i qwt.prf designer/designer.pro examples/examples.pri \
		textengines/mathml/qwtmathml.prf textengines/textengines.pri || die
	sed \
		-e 's:libqwt:libqwt6:g' \
		-i qwtbuild.pri || die

	use svg && echo "QWT_CONFIG += QwtSvg" >> qwtconfig.pri

	epatch "${FILESDIR}/${PN}-6.0.2-invalid-read.patch"
}

src_compile() {
	building() {
		# split compilation to allow parallel building
		emake sub-src
		emake
	}
	building

	if use static-libs; then
		sed "/QwtDll/d" -i qwtconfig.pri || die
		eqmake4
		building
		echo "CONFIG += QwtDll" >> qwtconfig.pri || die
	fi
}

src_test() {
	cd examples || die
	eqmake4 examples.pro
	emake
}

src_install () {
	qt4-r2_src_install

	use static-libs && dolib.a lib/libqwt.a

	if use doc; then
		dohtml -r doc/html/*
	fi
	if use examples; then
		# don't build examples - fix the qt files to build once installed
		cat > examples/examples.pri <<-EOF
			include( qwtconfig.pri )
			TEMPLATE     = app
			MOC_DIR      = moc
			INCLUDEPATH += "${EPREFIX}/usr/include/qwt6"
			DEPENDPATH  += "${EPREFIX}/usr/include/qwt6"
			LIBS        += -lqwt6
		EOF
		sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
		cp *.pri examples/ || die
		doins -r examples
	fi
}
