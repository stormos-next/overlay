# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnutls/gnutls-2.12.20.ebuild,v 1.11 2012/10/30 18:07:48 zerochaos Exp $

EAPI=4

inherit autotools libtool eutils

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"

if [[ "${PV}" == *pre* ]]; then
	SRC_URI="http://daily.josefsson.org/${P%.*}/${P%.*}-${PV#*pre}.tar.gz"
else
	MINOR_VERSION="${PV#*.}"
	MINOR_VERSION="${MINOR_VERSION%%.*}"
	if [[ $((MINOR_VERSION % 2)) == 0 ]]; then
		#SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"
		SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
	else
		SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.bz2"
	fi
	unset MINOR_VERSION
fi

# LGPL-2.1 for libgnutls library and GPL-3 for libgnutls-extra library.
LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="bindist +cxx doc examples guile lzo +nettle nls pkcs11 static-libs test zlib"

RDEPEND=">=dev-libs/libtasn1-0.3.4
	<dev-libs/libtasn1-3
	guile? ( >=dev-scheme/guile-1.8[networking] )
	nettle? ( >=dev-libs/nettle-2.1[gmp] )
	!nettle? ( >=dev-libs/libgcrypt-1.4.0 )
	nls? ( virtual/libintl )
	pkcs11? ( >=app-crypt/p11-kit-0.11 )
	zlib? ( >=sys-libs/zlib-1.2.3.1 )
	!bindist? ( lzo? ( >=dev-libs/lzo-2 ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/libtool
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test? ( app-misc/datefudge )"

S="${WORKDIR}/${P%_pre*}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS doc/TODO )

pkg_setup() {
	if use lzo && use bindist; then
		ewarn "lzo support is disabled for binary distribution of GnuTLS due to licensing issues."
	fi
}

src_prepare() {
	# tests/suite directory is not distributed.
	sed -i -e 's|AC_CONFIG_FILES(\[tests/suite/Makefile\])|:|' \
		configure.ac || die

	sed -i -e 's/imagesdir = $(infodir)/imagesdir = $(htmldir)/' \
		doc/Makefile.am || die

	local dir
	for dir in m4 lib/m4 libextra/m4; do
		rm -f "${dir}/lt"* "${dir}/libtool.m4"
	done
	find . -name ltmain.sh -exec rm {} \;

	epatch "${FILESDIR}"/${P}-AF_UNIX.patch
	epatch "${FILESDIR}"/${P}-libadd.patch
	epatch "${FILESDIR}"/${P}-glibc-2.16.patch
	epatch "${FILESDIR}"/${P}-guile-parallelmake.patch

	# support user patches
	epatch_user

	for dir in . lib libextra; do
		pushd "${dir}" > /dev/null
		sed -i -e '/^AM_INIT_AUTOMAKE/s/-Werror//' configure.ac || die
		eautoreconf
		popd > /dev/null
	done

	# Use sane .so versioning on FreeBSD.
	elibtoolize
}

src_configure() {
	local myconf
	use bindist && myconf="--without-lzo" || myconf="$(use_with lzo)"
	[[ "${VALGRIND_TESTS}" != "1" ]] && myconf+=" --disable-valgrind-tests"

	econf \
		--htmldir="${EPREFIX}"/usr/share/doc/${P}/html \
		--disable-silent-rules \
		$(use_enable cxx) \
		$(use_enable doc gtk-doc) \
		$(use_enable doc gtk-doc-pdf) \
		$(use_enable guile) \
		$(use_with !nettle libgcrypt) \
		$(use_enable nls) \
		$(use_with pkcs11 p11-kit) \
		$(use_enable static-libs static) \
		$(use_with zlib) \
		${myconf}
}

src_test() {
	if has_version dev-util/valgrind && [[ ${VALGRIND_TESTS} != 1 ]]; then
		elog
		elog "You can set VALGRIND_TESTS=\"1\" to enable Valgrind tests."
		elog
	fi

	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	if use doc; then
		dodoc doc/gnutls.{pdf,ps}
		dohtml doc/gnutls.html
	fi

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
