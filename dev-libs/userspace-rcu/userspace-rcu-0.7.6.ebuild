# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/userspace-rcu/userspace-rcu-0.7.6.ebuild,v 1.2 2013/04/03 17:34:24 scarabeus Exp $

EAPI=5

inherit eutils

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="http://lttng.org/urcu"
SRC_URI="http://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

DEPEND="test? ( sys-process/time )"

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
