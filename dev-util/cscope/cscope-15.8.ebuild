# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cscope/cscope-15.8.ebuild,v 1.1 2012/07/05 21:46:18 ulm Exp $

EAPI=4

inherit autotools elisp-common eutils

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="http://cscope.sourceforge.net/"
SRC_URI="mirror://sourceforge/cscope/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="emacs"

RDEPEND=">=sys-libs/ncurses-5.2
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${PN}-15.7a-ocs-sysdir.patch" #269305
	eautoreconf		  # prevent maintainer mode later on
}

src_compile() {
	emake
	if use emacs; then
		cd "${S}"/contrib/xcscope || die
		elisp-compile *.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog.old ChangeLog NEWS README TODO

	if use emacs; then
		cd "${S}"/contrib/xcscope || die
		elisp-install ${PN} *.el *.elc || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
		dobin cscope-indexer
	fi

	cd "${S}"/contrib/webcscope || die
	docinto webcscope
	dodoc INSTALL TODO cgi-lib.pl cscope hilite.c
	docinto webcscope/icons
	dodoc icons/*.gif
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
