# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/mcomix/mcomix-0.98.ebuild,v 1.1 2012/04/26 04:11:41 dirtyepic Exp $

EAPI="3"

SUPPORT_PYTHON_ABIS=1
PYTHON_USE_WITH="sqlite"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils fdo-mime python

DESCRIPTION="A fork of comix, a GTK image viewer for comic book archives."
HOMEPAGE="http://mcomix.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}
	app-arch/unrar
	>=dev-python/imaging-1.1.5
	>=dev-python/pygtk-2.14
	virtual/jpeg
	!media-gfx/comix"

src_install() {
	distutils_src_install
	insinto /etc/gconf/schemas/
	doins "${S}"/mime/comicbook.schemas || die
	dobin "${S}"/mime/comicthumb || die
	dodoc ChangeLog README || die
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	echo
	elog "You can optionally add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha."
	echo
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
