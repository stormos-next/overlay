# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio-paranoia/libcdio-paranoia-0.90_p1.ebuild,v 1.1 2013/04/15 20:57:40 ssuominen Exp $

EAPI=5
MY_P=${PN}-10.2+${PV/_p/+}
inherit autotools eutils

DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN%-*}/${MY_P}.tar.gz"

# COPYING-GPL from cdparanoia says "2 or later"
# COPYING-LGPL from cdparanoia says "2.1 or later" but 2 files are without the
# clause "or later" so we use LGPL-2.1 without +
LICENSE="GPL-3+ GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+cxx static-libs test"

RDEPEND="app-admin/eselect-cdparanoia
	>=${CATEGORY}/libcdio-0.90
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.90-mkdir_p.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-example-progs \
		$(use_enable cxx) \
		--disable-cpp-progs \
		$(use_enable static-libs static) \
		--with-cd-paranoia-name=libcdio-paranoia
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS
	prune_libtool_files
}

pkg_postinst() {
	eselect cdparanoia update ifunset
}

pkg_postrm() {
	eselect cdparanoia update ifunset
}
