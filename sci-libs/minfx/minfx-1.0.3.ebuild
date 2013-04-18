# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/minfx/minfx-1.0.3.ebuild,v 1.2 2013/02/04 07:09:37 jlec Exp $

EAPI=4

PYTHON_DEPEND=2
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Numerical optimisation library"
HOMEPAGE="http://gna.org/projects/minfx"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
