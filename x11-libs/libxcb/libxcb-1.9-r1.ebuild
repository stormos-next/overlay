# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxcb/libxcb-1.9-r1.ebuild,v 1.2 2013/03/06 13:11:03 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )
PYTHON_REQ_USE=xml

XORG_DOC=doc
XORG_MULTILIB=yes
inherit python-single-r1 xorg-2

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="http://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/libxcb"
[[ ${PV} != 9999* ]] && \
	SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="selinux"

RDEPEND="dev-libs/libpthread-stubs[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-lang/python[xml]
	dev-libs/libxslt
	>=x11-proto/xcb-proto-1.7-r1[${MULTILIB_USEDEP},${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9-python-3-iteritems.patch
	"${FILESDIR}"/${PN}-1.9-python-3-exception.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc build-docs)
		$(use_enable selinux)
		--enable-xinput
	)
}
