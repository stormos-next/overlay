# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rarian/rarian-0.8.1-r1.ebuild,v 1.13 2012/04/30 19:04:11 grobian Exp $

EAPI=4

inherit eutils libtool

DESCRIPTION="A documentation metadata library"
HOMEPAGE="http://rarian.freedesktop.org/"
SRC_URI="http://${PN}.freedesktop.org/Releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="dev-libs/libxslt"
DEPEND="${RDEPEND}
	!<app-text/scrollkeeper-9999"

DOCS=( ChangeLog NEWS README )

src_prepare() {
	# Fix uri of omf files produced by rarian-sk-preinstall, see bug #302900
	epatch "${FILESDIR}/${P}-fix-old-doc.patch"

	# remove unneeded line, bug #240564
	sed "s/ (foreign dist-bzip2 dist-gzip)//" -i configure || die "sed failed"

	elibtoolize ${ELTCONF}
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
