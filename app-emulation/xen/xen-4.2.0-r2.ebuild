# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen/xen-4.2.0-r2.ebuild,v 1.4 2013/03/08 10:33:14 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

if [[ $PV == *9999 ]]; then
	KEYWORDS=""
	REPO="xen-unstable.hg"
	EHG_REPO_URI="http://xenbits.xensource.com/${REPO}"
	S="${WORKDIR}/${REPO}"
	live_eclass="mercurial"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz"
fi

inherit mount-boot flag-o-matic python-single-r1 toolchain-funcs ${live_eclass}

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="http://xen.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug efi flask pae xsm"

DEPEND="efi? ( >=sys-devel/binutils-2.22[multitarget] )
	!efi? ( >=sys-devel/binutils-2.22[-multitarget] )"
REDEPEND=""
PDEPEND="~app-emulation/xen-tools-${PV}[${PYTHON_USEDEP}]"

RESTRICT="test"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

REQUIRED_USE="
	flask? ( xsm )"

pkg_setup() {
	python-single-r1_pkg_setup

	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64; then
			export XEN_TARGET_ARCH="x86_64"
		else
			die "Unsupported architecture!"
		fi
	fi

	if use flask ; then
		export "XSM_ENABLE=y"
		export "FLASK_ENABLE=y"
	elif use xsm ; then
		export "XSM_ENABLE=y"
	fi
}

src_prepare() {
	# Drop .config, fix gcc-4.6
	epatch "${FILESDIR}"/${PN}-4-fix_dotconfig-gcc.patch

	if use efi; then
		epatch "${FILESDIR}"/${PN}-4.2-efi.patch
		export EFI_VENDOR="gentoo"
		export EFI_MOUNTPOINT="boot"
	fi

	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \; || die "failed to re-set custom-cflags"
	fi

	# not strictly necessary to fix this
	sed -i 's/, "-Werror"//' "${S}/tools/python/setup.py" || die "failed to re-set setup.py"

	#Security patches
	epatch "${FILESDIR}"/${PN}-4-CVE-2012-4535-XSA-20.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-4537-XSA-22.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-4538-XSA-23.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-4539-XSA-24.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5510-XSA-26.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5513-XSA-29.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5514-XSA-30.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5515-XSA-31.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5525-XSA-32.patch \
		"${FILESDIR}"/${PN}-4-CVE-2012-5634-XSA-33.patch \
		"${FILESDIR}"/${PN}-4-CVE-2013-0151-XSA-27_34_35.patch \
		"${FILESDIR}"/${PN}-4-CVE-2013-0154-XSA-37.patch
}

src_configure() {
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	if use custom-cflags; then
		filter-flags -fPIE -fstack-protector
		replace-flags -O3 -O2
	else
		unset CFLAGS
	fi
}

src_compile() {
	# Send raw LDFLAGS so that --as-needed works
	emake CC="$(tc-getCC)" LDFLAGS="$(raw-ldflags)" LD="$(tc-getLD)" -C xen ${myopt}
}

src_install() {
	local myopt
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	#The 'make install' doesn't 'mkdir -p' the subdirs
	if use efi; then
		mkdir -p "${D}"${EFI_MOUNTPOINT}/efi/${EFI_VENDOR} || die
	fi

	emake LDFLAGS="$(raw-ldflags)" DESTDIR="${D}" -C xen ${myopt} install
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " http://www.gentoo.org/doc/en/xen-guide.xml"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"

	use pae && ewarn "This is a PAE build of Xen. It will *only* boot PAE kernels!"
	use efi && einfo "The efi executable is installed in boot/efi/gentoo"
}
