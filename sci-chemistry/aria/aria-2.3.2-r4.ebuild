# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/aria/aria-2.3.2-r4.ebuild,v 1.2 2013/01/17 20:24:41 jlec Exp $

EAPI=3

PYTHON_DEPEND="2"
PYTHON_USE_WITH="tk"

inherit base eutils python versionator

MY_P="${PN}$(get_version_component_range 1-2 ${PV})"

DESCRIPTION="Automated NOE assignment and NMR structure calculation"
HOMEPAGE="http://aria.pasteur.fr/"
SRC_URI="http://aria.pasteur.fr/archives/${MY_P}.2_latest.tar.gz"

SLOT="0"
LICENSE="cns"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-chemistry/clashlist
	sci-chemistry/procheck
	sci-libs/clashscore-db
	dev-python/numpy
	dev-python/matplotlib[tk]
	>=sci-chemistry/cns-1.2.1-r7[aria,openmp]
	dev-lang/tk
	>=sci-chemistry/ccpn-2.2
	dev-tcltk/tix"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"

pkg_nofetch(){
	einfo "Go to http://aria.pasteur.fr/archives/aria2.3.2.tar.gz/view, download ${A}"
	einfo "and place it in ${DISTDIR}"
}

src_test(){
	export CCPNMR_TOP_DIR="${EPREFIX}"/$(python_get_sitedir)
	export PYTHONPATH=.:${CCPNMR_TOP_DIR}/ccpn/python
	$(PYTHON) check.py || die
}

src_install(){
	insinto "$(python_get_sitedir)/${PN}"
	doins -r src aria2.py || die "failed to install ${PN}"
	insinto "$(python_get_sitedir)/${PN}"/cns
	doins -r cns/{protocols,toppar,src/helplib} || die "failed to install cns part"

	if use examples; then
		insinto /usr/share/${P}/
		doins -r examples || die
	fi

	# ENV
	cat >> "${T}"/20aria <<- EOF
	ARIA2="${EPREFIX}/$(python_get_sitedir)/${PN}"
	EOF

	doenvd "${T}"/20aria

	# Launch Wrapper
	cat >> "${T}"/aria <<- EOF
	#!/bin/sh
	export CCPNMR_TOP_DIR="${EPREFIX}/$(python_get_sitedir)"
	export PYTHONPATH="${EPREFIX}/$(python_get_sitedir)/ccpn/python"
	exec "$(PYTHON)" -O "\${ARIA2}"/aria2.py \$@
	EOF

	dobin "${T}"/aria || die "failed to install wrapper"
	dosym aria /usr/bin/aria2

	dodoc README || die
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
