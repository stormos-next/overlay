# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gummi/gummi-0.6.4.ebuild,v 1.3 2012/08/18 23:27:33 johu Exp $

EAPI=4
inherit base eutils

DESCRIPTION="Simple LaTeX editor for GTK+"
HOMEPAGE="http://gummi.midnightcoding.org"
SRC_URI="http://dev.midnightcoding.org/attachments/download/298/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

LANGS="ar ca cs da de el es fr it nl pl pt pt_BR ro ru sv zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="app-text/gtkspell:2
	>=dev-libs/glib-2.28.6
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	>=x11-libs/gtk+-2.24:2
	x11-libs/gtksourceview:2.0"
DEPEND="${RDEPEND}
	app-text/poppler[cairo]
	x11-libs/gtksourceview:2.0
	x11-libs/pango"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	strip-linguas ${LANGS}
}

pkg_postinst() {
	elog "Gummi >=0.4.8 supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-** packages"
	elog "for your language of choice."
}
