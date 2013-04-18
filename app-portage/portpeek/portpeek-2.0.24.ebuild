# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portpeek/portpeek-2.0.24.ebuild,v 1.7 2013/03/08 19:53:34 mpagano Exp $

EAPI="4"
PYTHON_DEPEND="*:2.7"

inherit python

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI="http://www.mpagano.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-portage/gentoolkit-0.3.0.5
	>=sys-apps/portage-2.1.10.49"

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
