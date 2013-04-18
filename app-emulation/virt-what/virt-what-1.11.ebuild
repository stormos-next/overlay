# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/virt-what/virt-what-1.11.ebuild,v 1.1 2011/07/29 19:10:04 cardoe Exp $

EAPI=3

inherit eutils autotools

DESCRIPTION="Detects if the current machine is running in a virtual machine"
HOMEPAGE="http://people.redhat.com/~rjones/virt-what/"
SRC_URI="http://people.redhat.com/~rjones/virt-what/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="app-shells/bash
		sys-apps/dmidecode"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
