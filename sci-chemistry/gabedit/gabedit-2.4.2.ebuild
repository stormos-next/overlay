# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gabedit/gabedit-2.4.2.ebuild,v 1.4 2012/12/14 10:12:42 ulm Exp $

EAPI=4

inherit eutils toolchain-funcs versionator

MY_PN=${PN/g/G}
MY_PV=$(delete_all_version_separators)
MY_P="${MY_PN}Src${MY_PV}"

DESCRIPTION="GUI for computational chemistry packages"
HOMEPAGE="http://gabedit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/gl2ps
	x11-libs/pango
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gold.patch

	sed -i "/rmdir tmp/d" "${S}"/Makefile
	sed \
		-e "/GTK_DISABLE_DEPRECATED/s:define:undef:g" \
		-i "${S}/Config.h" || die
	sed -e 's:-g::g' -i Makefile || die
	cp "${FILESDIR}"/CONFIG.Gentoo "${S}"/CONFIG

	if use openmp && tc-has-openmp; then
		cat <<- EOF >> "${S}/CONFIG"
			OMPLIB=-fopenmp
			OMPCFLAGS=-DENABLE_OMP -fopenmp
		EOF
	fi
	echo "COMMONCFLAGS = ${CFLAGS} -DENABLE_DEPRECATED \$(OMPCFLAGS) \$(DRAWGEOMGL)" >> CONFIG

	tc-export CC
}

src_compile() {
	emake clean
	emake external_gl2ps=1
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog
}
