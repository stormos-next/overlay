# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ilmbase/ilmbase-2.0.0.ebuild,v 1.4 2013/03/21 15:49:17 ssuominen Exp $

EAPI=5
inherit autotools eutils #libtool

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://dev.gentoo.org/~ssuominen/openexr-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/10" # from SONAME
KEYWORDS="~alpha ~amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

S=${WORKDIR}/openexr-${PV}/IlmBase

src_prepare() {
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	epatch "${FILESDIR}"/${P}-underlinking.patch
	eautoreconf
#	elibtoolize
}

src_configure() {
	export ac_cv_header_ucontext_h=no #461594
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	prune_libtool_files
}
