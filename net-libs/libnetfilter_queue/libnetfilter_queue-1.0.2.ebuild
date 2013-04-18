# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnetfilter_queue/libnetfilter_queue-1.0.2.ebuild,v 1.7 2013/03/26 11:43:28 ago Exp $

EAPI=5
inherit autotools-utils linux-info

DESCRIPTION="API to packets that have been queued by the kernel packet filter"
HOMEPAGE="http://www.netfilter.org/projects/libnetfilter_queue/"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="static-libs"

RDEPEND="
	>=net-libs/libmnl-1.0.3
	>=net-libs/libnfnetlink-0.0.41
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NETFILTER_NETLINK_QUEUE"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && ewarn "requires at least 2.6.14 kernel version"
}
