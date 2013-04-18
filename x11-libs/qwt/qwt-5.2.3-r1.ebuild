# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-5.2.3-r1.ebuild,v 1.1 2013/03/05 12:56:06 jlec Exp $

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-macos"
SLOT="5"
IUSE="doc examples static-libs svg"

DEPEND="
	dev-qt/qtgui:4
	doc? ( !<media-libs/coin-3.1.3[doc] )
	svg? ( dev-qt/qtsvg:4 )"
RDEPEND="${DEPEND}"

DOCS="CHANGES README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-install_qt.patch
	sed -e "/QwtVersion/s:5.2.2.:${PV}:g" -i ${PN}.prf || die

	cat > qwtconfig.pri <<-EOF
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		headers.path = "${EPREFIX}/usr/include/qwt5"
		doc.path = "${EPREFIX}/usr/share/doc/${PF}"
		CONFIG += qt warn_on thread release
		CONFIG += QwtDll
		CONFIG += QwtPlot QwtWidgets QwtDesigner
		VERSION = ${PV}
		QWT_VERSION = ${PV/_*}
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/share/qt4/mkspecs/features"
	EOF
	sed -i -e 's/headers doc/headers/' src/src.pro || die
	use svg && echo >> qwtconfig.pri "CONFIG += QwtSVGItem"
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
		insinto /usr/share/doc/${PF}
		rm doc/man/*/*license*
		doman doc/man/*/*
		doins -r doc/html
	fi
	if use examples; then
		# don't build examples - fix the qt files to build once installed
		cat > examples/examples.pri <<-EOF
			include( qwtconfig.pri )
			TEMPLATE     = app
			MOC_DIR      = moc
			INCLUDEPATH += "${EPREFIX}/usr/include/qwt5"
			DEPENDPATH  += "${EPREFIX}/usr/include/qwt5"
			LIBS        += -lqwt
		EOF
		sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
		cp *.pri examples/ || die
		doins -r examples
	fi
}
