# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-lib-bin-symlink/eselect-lib-bin-symlink-9999.ebuild,v 1.4 2013/02/19 02:50:40 zmedico Exp $

EAPI=5

#if LIVE
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"
AUTOTOOLS_AUTORECONF=1
inherit git-2
#endif

inherit autotools-utils

DESCRIPTION="An eselect library to manage executable symlinks"
HOMEPAGE="https://bitbucket.org/mgorny/eselect-lib-bin-symlink/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~amd64-fbsd ~amd64-linux ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc64-solaris ~sparc-solaris ~x64-freebsd ~x64-macos ~x64-solaris ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~arm-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"
#if LIVE

KEYWORDS=
SRC_URI=
#endif
