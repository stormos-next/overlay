# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/build-docbook-catalog/build-docbook-catalog-1.19.1.ebuild,v 1.8 2013/02/07 15:22:04 aballier Exp $

EAPI="4"

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="http://sources.gentoo.org/gentoo-src/build-docbook-catalog/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~floppym/distfiles/${P}.tar.xz
	http://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-solaris"
IUSE="userland_BSD"

RDEPEND="|| ( sys-apps/util-linux app-misc/getopt )
	!<app-text/docbook-xsl-stylesheets-1.73.1
	userland_BSD? ( sys-apps/flock )
	dev-libs/libxml2"
DEPEND=""

pkg_postinst() {
	# New version -> regen files
	build-docbook-catalog
}
