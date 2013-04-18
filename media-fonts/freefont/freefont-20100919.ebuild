# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont/freefont-20100919.ebuild,v 1.2 2013/02/02 22:44:06 ago Exp $

EAPI=3

inherit font

DESCRIPTION="TrueType Unicode fonts from the Free UCS Outline Fonts Project"
HOMEPAGE="http://savannah.nongnu.org/projects/freefont/"
SRC_URI="mirror://gnu/freefont/${PN}-ttf-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE=""

FONT_SUFFIX="ttf"
DOCS="CREDITS"

RESTRICT="strip binchecks"
