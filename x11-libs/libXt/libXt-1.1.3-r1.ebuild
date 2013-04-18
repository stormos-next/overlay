# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXt/libXt-1.1.3-r1.ebuild,v 1.1 2013/02/26 16:16:24 mgorny Exp $

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2 toolchain-funcs

DESCRIPTION="X.Org Xt library"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-proto/xproto[${MULTILIB_USEDEP}]
	x11-proto/kbproto[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

pkg_setup() {
	xorg-2_pkg_setup

	tc-is-cross-compiler && export CFLAGS_FOR_BUILD="${BUILD_CFLAGS}"
}
