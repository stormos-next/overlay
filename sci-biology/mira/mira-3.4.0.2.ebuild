# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mira/mira-3.4.0.2.ebuild,v 1.1 2012/11/07 22:29:56 jlec Exp $

EAPI=4

MIRA_3RDPARTY_PV="06-07-2012"

inherit autotools base multilib

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Solexa / Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
SRC_URI="
	mirror://sourceforge/mira-assembler/${P}.tar.bz2
	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

CDEPEND="
	dev-libs/boost
	dev-util/google-perftools"
DEPEND="${CDEPEND}
	app-editors/vim-core
	dev-libs/expat"
RDEPEND="${CDEPEND}"

DOCS=( AUTHORS GETTING_STARTED NEWS README HELP_WANTED
	THANKS doc/3rdparty/scaffolding_MIRA_BAMBUS.pdf )

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die
	epatch \
		"${FILESDIR}"/${P}-boost-1.50.patch
	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	econf \
		--with-boost="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-thread=boost_thread-mt
}

#src_compile() {
#	base_src_compile
#	# TODO: resolve docbook incompatibility for building docs
#	#if use doc; then emake -C doc clean docs || die; fi
#}

src_install() {
	base_src_install
	dobin "${WORKDIR}"/3rdparty/{sff_extract,qual2ball,*.pl}
}

pkg_postinst() {
	einfo "Documentation is no longer built, you can find it at:"
	einfo "http://mira-assembler.sourceforge.net/docs/DefinitiveGuideToMIRA.html"
}
