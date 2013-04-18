# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nedit/nedit-5.5_p20110116.ebuild,v 1.4 2012/10/24 18:58:01 ulm Exp $

EAPI=2

inherit toolchain-funcs eutils

DESCRIPTION="Multi-purpose text editor for the X Window System"
HOMEPAGE="http://nedit.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXp
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	|| ( dev-util/yacc sys-devel/bison )
	dev-lang/perl"

S="${WORKDIR}/${PN}"

src_prepare() {
	#respecting LDFLAGS, bug #208189
	epatch \
		"${FILESDIR}"/nedit-5.5_p20090914-ldflags.patch \
		"${FILESDIR}"/${P}-40_Pointer_to_Integer.patch
	sed \
		-e "s:bin/:${EPREFIX}/bin/:g" \
		-i Makefile source/preferences.c source/help_data.h source/nedit.c Xlt/Makefile || die
	sed \
		-e "s:nc:neditc:g" -i doc/nc.pod || die
}

src_configure() {
	sed -i -e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:" -e "s:check_tif_rule::" \
		makefiles/Makefile.linux || die
	sed -i -e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:"                  \
		   -e "s:MOTIFDIR=/usr/local:MOTIFDIR=${EPREFIX}/usr:" \
		   -e "s:-lX11:-lX11 -lXmu -liconv:"                   \
		   -e "s:check_tif_rule::"                             \
		makefiles/Makefile.macosx || die
}

src_compile() {
	case ${CHOST} in
		*-darwin*)
			emake CC="$(tc-getCC)" macosx || die
			;;
		*-linux*)
			emake CC="$(tc-getCC)" linux || die
			;;
	esac
	emake VERSION="NEdit ${PV}" -j1 -C doc all || die
}

src_install() {
	dobin source/nedit || die
	newbin source/nc neditc || die
	newman doc/nedit.man nedit.1 || die
	newman doc/nc.man neditc.1 || die

	dodoc README ReleaseNotes ChangeLog || die
	cd doc
	dodoc nedit.doc NEdit.ad faq.txt || die
	dohtml nedit.html || die
}
