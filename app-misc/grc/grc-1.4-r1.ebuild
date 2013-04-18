# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/grc/grc-1.4-r1.ebuild,v 1.4 2013/03/30 13:00:26 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} pypy{1_8,1_9} )

inherit eutils python-r1

DESCRIPTION="Generic Colouriser beautifies your logfiles or output of commands"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/grc.html"
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-support-more-files.patch \
		"${FILESDIR}"/${P}-ipv6.patch
}

src_install() {
	python_foreach_impl python_doscript grc grcat

	insinto /usr/share/grc
	doins conf.* "${FILESDIR}"/conf.*

	insinto /etc
	doins grc.conf

	dodoc README INSTALL TODO CHANGES CREDITS
	doman grc.1 grcat.1
}
