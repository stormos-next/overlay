# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/popwin/popwin-0.5.1.ebuild,v 1.1 2012/09/08 08:59:28 ulm Exp $

EAPI=4
NEED_EMACS=22

inherit elisp eutils

DESCRIPTION="Popup window manager for Emacs"
HOMEPAGE="https://github.com/m2ym/popwin-el/"
SRC_URI="https://github.com/m2ym/popwin-el/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md NEWS.md"

src_unpack() {
	unpack ${A}
	mv m2ym-popwin-el-* ${P} || die
}
