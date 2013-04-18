# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nvidia-cuda-sdk/nvidia-cuda-sdk-2.2-r1.ebuild,v 1.6 2012/02/05 05:48:44 vapier Exp $

EAPI=2

inherit unpacker toolchain-funcs

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"

CUDA_V=${PV//./_}

SRC_URI="http://developer.download.nvidia.com/compute/cuda/${CUDA_V}/sdk/cudasdk_${PV}_linux.run"
LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug +doc emulation +examples"

RDEPEND=">=dev-util/nvidia-cuda-toolkit-2.2
	examples? ( !emulation? ( >=x11-drivers/nvidia-drivers-180.22 ) )
	media-libs/freeglut"
DEPEND="${RDEPEND}
	<sys-devel/gcc-4.4"

S="${WORKDIR}"

RESTRICT="binchecks"

pkg_setup() {
	if [ "$(gcc-major-version)" == "4" -a $(gcc-minor-version) -ge 4 ]; then
		eerror "This package requires <=sys-devel/gcc-4.3 to build sucessfully."
		eerror "Please use gcc-config to switch to a compatible GCC version."
		die "<=sys-devel/gcc-4.3 required"
	fi
}

src_prepare() {
	sed -i -e 's:CUDA_INSTALL_PATH ?= .*:CUDA_INSTALL_PATH ?= /opt/cuda:' sdk/common/common.mk
}

src_compile() {
	if ! use examples; then
		return
	fi
	local myopts=""

	if use emulation; then
		myopts="emu=1"
	fi

	if use debug; then
		myopts="${myopts} dbg=1"
	fi

	cd "${S}/sdk"
	emake cuda-install=/opt/cuda ${myopts} || die
}

src_install() {
	cd "${S}/sdk"

	if ! use doc; then
		rm -rf doc ReleaseNotes.htm releaseNotesData
	fi

	if ! use examples; then
		rm -rf projects bin tools
	fi

	for f in $(find .); do
		local t="$(dirname ${f})"
		if [[ "${t/obj\/}" != "${t}" || "${t##*.}" == "a" ]]; then
			continue
		fi

		if [[ -x "${f}" && ! -d "${f}" ]]; then
			exeinto "/opt/cuda/sdk/${t}"
			doexe "${f}"
		else
			insinto "/opt/cuda/sdk/${t}"
			doins "${f}"
		fi
	done
}
