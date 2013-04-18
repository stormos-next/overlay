# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/aufs-sources/aufs-sources-3.6.11-r3.ebuild,v 1.1 2013/03/18 07:05:04 jlec Exp $

EAPI=5

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="13"
K_DEBLOB_AVAILABLE="1"
inherit kernel-2 eutils
detect_version
detect_arch

AUFS_VERSION=3.6.11
AUFS_TARBALL="aufs-sources-${AUFS_VERSION}.tar.xz"
# git archive -v --remote=git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git aufs3.7 > ${AUFS_TARBALL}
AUFS_URI="http://dev.gentoo.org/~jlec/distfiles/${AUFS_TARBALL}"

KEYWORDS="~amd64 ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches http://aufs.sourceforge.net/"
IUSE="deblob module"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree and aufs3 support"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${AUFS_URI}"

UNIPATCH_LIST="
	"${WORKDIR}"/aufs3-kbuild.patch
	"${WORKDIR}"/aufs3-base.patch"
#	${WORKDIR}/aufs3-proc_map.patch"

src_unpack() {
	use module && UNIPATCH_LIST+=" "${WORKDIR}"/aufs3-standalone.patch"
	unpack ${AUFS_TARBALL}
	kernel-2_src_unpack
}

src_prepare() {
	if ! use module; then
		sed -e 's:tristate:bool:g' -i "${WORKDIR}"/fs/aufs/Kconfig || die
	fi
	cp -i "${WORKDIR}"/include/linux/aufs_type.h include/linux/aufs_type.h || die
	cp -ri "${WORKDIR}"/{Documentation,fs} . || die
	sed -i "s:__user::g" include/linux/aufs_type.h || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	if ! has_version sys-fs/aufs-util; then
		einfo "In order to use aufs FS you need to install sys-fs/aufs-util"
	fi
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
