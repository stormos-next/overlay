# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/uemacs-pk/uemacs-pk-4.0.15_p20120526.ebuild,v 1.5 2013/02/28 17:34:52 ulm Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="uEmacs/PK is an enhanced version of MicroEMACS"
HOMEPAGE="http://git.kernel.org/?p=editors/uemacs/uemacs.git;a=summary
	ftp://ftp.cs.helsinki.fi/pub/Software/Local/uEmacs-PK"
# snapshot from git repo
SRC_URI="mirror://gentoo/uemacs-${PV}.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/uemacs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.15_p20110825-gentoo.patch
}

src_compile() {
	emake V=1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	dobin em
	insinto /usr/share/${PN}
	doins emacs.hlp
	newins emacs.rc .emacsrc
	dodoc README readme.39e emacs.ps UTF-8-demo.txt
}

pkg_postinst() {
	einfo "If you are upgrading from version 4.0.18, please note that the"
	einfo "executable is now installed as \"em\" instead of \"uemacs\"."
}
