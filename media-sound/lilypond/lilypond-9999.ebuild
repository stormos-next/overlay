# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lilypond/lilypond-9999.ebuild,v 1.2 2013/01/14 03:04:10 radhermit Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit elisp-common autotools eutils git-2 python-single-r1

EGIT_REPO_URI="git://git.sv.gnu.org/lilypond.git"

DESCRIPTION="GNU Music Typesetter"
HOMEPAGE="http://lilypond.org/"

SLOT="0"
LICENSE="GPL-3 FDL-1.3"
KEYWORDS=""
IUSE="debug emacs profile vim-syntax"

RDEPEND=">=app-text/ghostscript-gpl-8.15
	>=dev-scheme/guile-1.8.2[deprecated,regex]
	media-fonts/urw-fonts
	media-libs/fontconfig
	media-libs/freetype:2
	>=x11-libs/pango-1.12.3
	emacs? ( virtual/emacs )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/t1utils
	dev-lang/perl
	dev-texlive/texlive-metapost
	virtual/pkgconfig
	media-gfx/fontforge
	>=sys-apps/texinfo-4.11
	>=sys-devel/bison-2.0
	sys-devel/flex
	sys-devel/gettext
	sys-devel/make"

# Correct output data for tests isn't bundled with releases
RESTRICT="test"

src_prepare() {
	if ! use vim-syntax ; then
		sed -i -e "s/vim//" GNUmakefile.in || die
	fi

	sed -i -e "s/OPTIMIZE -g/OPTIMIZE/" aclocal.m4 || die

	eautoreconf
}

src_configure() {
	# documentation generation currently not supported since it requires a newer
	# version of texi2html than is currently in the tree

	econf \
		--with-ncsb-dir=/usr/share/fonts/urw-fonts \
		--disable-documentation \
		--disable-optimising \
		--disable-pipe \
		$(use_enable debug debugging) \
		$(use_enable profile profiling)
}

src_compile() {
	default

	if use emacs ; then
		elisp-compile elisp/lilypond-{font-lock,indent,mode,what-beat}.el \
			|| die "elisp-compile failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" vimdir=/usr/share/vim/vimfiles install

	# remove elisp files since they are in the wrong directory
	rm -r "${ED}"/usr/share/emacs || die

	if use emacs ; then
		elisp-install ${PN} elisp/*.{el,elc} elisp/out/*.el \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el
	fi

	python_fix_shebang "${ED}"

	dodoc HACKING README.txt
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
