# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlto/xmlto-0.0.25.ebuild,v 1.2 2012/04/26 17:23:43 aballier Exp $

EAPI=4
inherit eutils

DESCRIPTION="script for converting XML and DocBook formatted documents to a variety of output formats"
HOMEPAGE="https://fedorahosted.org/xmlto/"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="latex"

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.62.0-r1
	app-text/docbook-xml-dtd:4.2
	app-shells/bash
	dev-libs/libxslt
	sys-apps/grep
	|| ( >=sys-apps/coreutils-6.10-r1 sys-freebsd/freebsd-ubin )
	|| ( sys-apps/util-linux app-misc/getopt )
	|| ( sys-apps/which sys-freebsd/freebsd-ubin )
	latex? ( >=app-text/passivetex-1.25 >=dev-tex/xmltex-1.9-r2 )"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS="AUTHORS ChangeLog FAQ NEWS README THANKS"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch
}

src_configure() {
	export BASH
	has_version sys-apps/util-linux || export GETOPT=getopt-long
	econf
}
