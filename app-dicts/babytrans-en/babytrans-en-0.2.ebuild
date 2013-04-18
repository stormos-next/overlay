# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/babytrans-en/babytrans-en-0.2.ebuild,v 1.6 2009/10/17 22:40:19 halcy0n Exp $

MY_P="english.dic.gz"
MY_F="english.dic"
DESCRIPTION="English dictionary for Babytrans"
HOMEPAGE="ftp://ftp.ac-grenoble.fr/ge/languages/babylon_dict/"
SRC_URI="${MY_P}"

LICENSE="Babylon"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Due to license restrictions that may apply to the file in"
	einfo "this package, it has fetch restrictions turned on. This"
	einfo "means that you must download ${MY_P} file manually from"
	einfo "${HOMEPAGE} or copy it"
	einfo "from a windows installation of babylon and put it in "
	einfo "${DISTDIR}. Finally note that having a license of"
	einfo "babylon is desired in order to use this package"
}

src_install() {
	cd "${WORKDIR}"
	insinto /usr/share/babytrans
	doins ${MY_F} || die "Unable to install file"
}
