# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkg-config-lite/Attic/pkg-config-lite-0.26.1.ebuild,v 1.3 2012/07/13 09:48:49 ssuominen dead $

EAPI=4

inherit versionator

MY_P=$(version_format_string '${PN}-$1.$2-$3')
DESCRIPTION="pkg-config without glib dependency"
HOMEPAGE="http://sourceforge.net/projects/pkgconfiglite/"
SRC_URI="mirror://sourceforge/pkgconfiglite/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-solaris"
IUSE="+pkg-config"

DEPEND="
	pkg-config? (
		!dev-util/pkgconf[pkg-config]
		!dev-util/pkgconfig
		!dev-util/pkgconfig-openbsd[pkg-config]
	)
	dev-libs/popt"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf --with-installed-popt
}
