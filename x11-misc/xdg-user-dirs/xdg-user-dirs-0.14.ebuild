# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-user-dirs/xdg-user-dirs-0.14.ebuild,v 1.12 2012/05/19 12:09:43 blueness Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A tool to help manage 'well known' user directories"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"
SRC_URI="http://user-dirs.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="gtk nls"

RDEPEND=""
DEPEND="nls? ( sys-devel/gettext )"
PDEPEND="gtk? (
	nls? ( x11-misc/xdg-user-dirs-gtk )
	)"

DOCS=( AUTHORS ChangeLog NEWS )

src_prepare() {
	epatch "${FILESDIR}"/${P}-strndup-nls.patch
	eautoreconf # for the above patch
}

src_configure() {
	econf $(use_enable nls)
}
