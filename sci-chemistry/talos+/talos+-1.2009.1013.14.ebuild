# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/talos+/talos+-1.2009.1013.14.ebuild,v 1.2 2010/06/16 14:11:07 jlec Exp $

EAPI="3"

inherit eutils

DESCRIPTION="A Hybrid method for predicting protein backbone torsion angles from NMR CS"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/TALOS+/index.html"
SRC_URI="http://spin.niddk.nih.gov/bax/software/TALOS+/talos+.tar.Z -> ${P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	dev-lang/tcl
	sci-chemistry/rasmol"
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/rama+.patch
}

src_install() {
	sed \
		-e "s:DIR_HERE:${EPREFIX}/opt/${PN}/:g" \
		-i *+

	insinto /opt/${PN}/
	doins -r tab rama.{dat,gif} || die

	exeinto /opt/${PN}/bin
	newexe bin/TALOS+.linux TALOS+ || die
	doexe rama+.tcl || die

	dobin bmrb2talos.com talos2dyana.com talos2xplor.com talos+ rama+ || die

	dodoc README || die
}
