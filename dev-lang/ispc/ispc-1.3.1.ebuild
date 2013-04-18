# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ispc/ispc-1.3.1.ebuild,v 1.2 2013/01/11 22:33:31 ottxor Exp $

EAPI=4

PYTHON_DEPEND="2"

inherit base toolchain-funcs python

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="http://ispc.github.com/"

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/ispc/ispc.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://github/${PN}/${PN}/tarball/v${PV} -> ${P}.tar.gz"
fi

LICENSE="BSD BSD-2 UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=sys-devel/clang-3.0
	>=sys-devel/llvm-3.0
	"
DEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" OPT="${CXXFLAGS}" CXX="$(tc-getCXX)" CPP="$(tc-getCPP)"
}

src_install() {
	dobin ispc
	dodoc README.rst

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		docompress -x "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}
