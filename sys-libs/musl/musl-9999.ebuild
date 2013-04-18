# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.3 2012/12/26 19:16:47 blueness Exp $

EAPI=4

inherit eutils flag-o-matic multilib toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.musl-libc.org/musl"
	inherit git-2
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"
if [[ ${PV} != "9999" ]] ; then
	PATCH_VER=""
	SRC_URI="http://www.musl-libc.org/releases/${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~arm ~mips"
fi

LICENSE="MIT"
SLOT="0"
IUSE="crosscompile_opts_headers-only"

S=${WORKDIR}/${MY_P}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

just_headers() {
	use crosscompile_opts_headers-only && is_crosscompile
}

pkg_setup() {
	if [ ${CTARGET} == ${CHOST} ] ; then
		case ${CHOST} in
		*-musl*) ;;
		*) die "Use sys-devel/crossdev to build a musl toolchain" ;;
		esac
	fi
}

src_configure() {
	tc-export CC

	./configure \
		--target="${CTARGET}" \
		--prefix="/usr" \
		--disable-gcc-wrapper
}

src_compile() {
	emake include/bits/alltypes.h || die
	just_headers && return 0

	emake || die
}

src_install() {
	local sysroot=${D}
	is_crosscompile && sysroot+="/usr/${CTARGET}"

	local target="install"
	just_headers && target="install-headers"
	emake DESTDIR="${sysroot}" ${target} || die

	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		dosym usr/include /usr/${CTARGET}/sys-include
	fi
}

pkg_postinst() {
	is_crosscompile && return 0

	[ "${ROOT}" != "/" ] && return 0
	# update cache before reloading init
	ldconfig
	# reload init ...
	/sbin/telinit U 2>/dev/null
}
