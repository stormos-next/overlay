# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/replicant/replicant-0.1.1.ebuild,v 1.1 2013/02/10 07:09:48 patrick Exp $
EAPI=4

DESCRIPTION="Hyperdex replicant support library"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND=">=dev-libs/libpo6-0.2
	>=dev-libs/libe-0.2
	>=dev-libs/busybee-0.2
	dev-libs/leveldb
	dev-cpp/glog"
RDEPEND="${DEPEND}"
