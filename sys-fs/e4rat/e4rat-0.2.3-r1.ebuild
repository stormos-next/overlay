# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/e4rat/e4rat-0.2.3-r1.ebuild,v 1.5 2013/01/21 20:49:42 pacho Exp $

EAPI=5

inherit cmake-utils linux-info readme.gentoo

DESCRIPTION="Toolset to accelerate the boot process and application startup"
HOMEPAGE="http://e4rat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/perl:=
	>=dev-libs/boost-1.42:=
	sys-fs/e2fsprogs
	sys-process/audit
	sys-process/lsof"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~AUDITSYSCALL"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.2-shared-build.patch
	"${FILESDIR}"/${PN}-0.2.2-libdir.patch
	"${FILESDIR}"/${P}-boostfsv3.patch
)

pkg_setup() {
	check_extra_config
	DOC_CONTENTS="Please consult the following link if you need help
		configuring your system: http://en.gentoo-wiki.com/wiki/E4rat"
}

src_install() {
	cmake-utils_src_install
	# relocate binaries to /sbin. If someone knows of a better way to do it
	# please do tell me
	dodir sbin
	find "${D}"/usr/sbin -type f -exec mv {} "${D}"/sbin/. \; \
		|| die

	dodoc README
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if has_version sys-apps/preload; then
		elog "It appears you have sys-apps/preload installed. This may"
		elog "has negative effects on ${PN}. You may want to disable preload"
		elog "when using ${PN}."
	fi
}
