# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect/eselect-1.2.18.ebuild,v 1.7 2013/01/06 13:44:45 ulm Exp $

EAPI=2

inherit bash-completion-r1

DESCRIPTION="Gentoo's multi-purpose configuration and management tool"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="sys-apps/sed
	|| (
		sys-apps/coreutils
		sys-freebsd/freebsd-bin
		app-misc/realpath
	)"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"
RDEPEND="!app-admin/eselect-news
	${RDEPEND}
	sys-apps/file
	sys-libs/ncurses"

# Commented out: only few users of eselect will edit its source
#PDEPEND="emacs? ( app-emacs/gentoo-syntax )
#	vim-syntax? ( app-vim/eselect-syntax )"

src_compile() {
	emake || die

	if use doc; then
		emake html || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	newbashcomp misc/${PN}.bashcomp ${PN} || die
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt || die

	if use doc; then
		dohtml *.html doc/* || die
	fi

	# needed by news module
	keepdir /var/lib/gentoo/news
	fowners root:portage /var/lib/gentoo/news || die
	fperms g+w /var/lib/gentoo/news || die
}

pkg_postinst() {
	# fowners in src_install doesn't work for the portage group:
	# merging changes the group back to root
	[[ -z ${EROOT} ]] && local EROOT=${ROOT}
	chgrp portage "${EROOT}/var/lib/gentoo/news" \
		&& chmod g+w "${EROOT}/var/lib/gentoo/news"
}
