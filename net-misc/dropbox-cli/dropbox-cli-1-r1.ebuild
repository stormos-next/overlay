# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbox-cli/dropbox-cli-1-r1.ebuild,v 1.6 2013/02/14 20:20:26 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )

inherit python-r1

DESCRIPTION="Cli interface for dropbox daemon (python)"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.py.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="net-misc/dropbox
	${PYTHON_DEPS}"

S=${WORKDIR}

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
}
