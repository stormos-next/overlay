# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp-xsl/yelp-xsl-3.6.1.ebuild,v 1.22 2013/04/01 18:24:56 ago Exp $

EAPI="5"

inherit gnome.org

DESCRIPTION="XSL stylesheets for yelp"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2+ LGPL-2.1+ MIT FDL-1.1+"
SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~amd64-linux ~arm-linux ~x86-linux"

RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/itstool
	sys-devel/gettext
	virtual/awk
	virtual/pkgconfig"
