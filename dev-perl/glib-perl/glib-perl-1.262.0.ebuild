# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/glib-perl/glib-perl-1.262.0.ebuild,v 1.9 2012/12/27 09:38:32 armin76 Exp $

EAPI=4

MY_PN=Glib
MODULE_AUTHOR=TSCH
MODULE_VERSION=1.262
inherit perl-module

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-perl/extutils-pkgconfig-1.0.0
	>=dev-perl/extutils-depends-0.300.0
"

SRC_TEST="do"
