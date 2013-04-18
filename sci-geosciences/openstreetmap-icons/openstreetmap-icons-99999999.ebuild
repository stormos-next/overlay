# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/openstreetmap-icons/openstreetmap-icons-99999999.ebuild,v 1.1 2011/06/01 12:17:46 scarabeus Exp $

EAPI=4

ESVN_REPO_URI="http://svn.openstreetmap.org/applications/share/map-icons/"
[[ ${PV} == 99999999 ]] && EVCS_ECLASS=subversion
# tar.bz2 generated extracting files from above SVN repo
inherit cmake-utils ${EVCS_ECLASS}
unset EVCS_ECLASS

DESCRIPTION="openstreetmap icons"
HOMEPAGE="http://www.openstreetmap.org/"
[[ ${PV} == 99999999 ]] || SRC_URI="http://dev.gentoo.org/~scarabeus/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
[[ ${PV} == 99999999 ]] || KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-perl/ImageInfo
	media-gfx/imagemagick[perl]
	dev-perl/File-Slurp
	dev-perl/DBD-SQLite
	dev-perl/XML-Twig"

RDEPEND=""

S="${WORKDIR}/map-icons/"

src_compile() {
	cmake-utils_src_compile
	cp icons.* "${CMAKE_BUILD_DIR}"
	cd "${CMAKE_BUILD_DIR}"
	perl "${S}"/tools/create_geoinfo-db.pl --lang=en --source=icons.xml \
	    || die "create en geoinfo-db failed"
	perl "${S}"/tools/create_geoinfo-db.pl --lang=de --source=icons.xml \
	    || die "create de geoinfo-db failed"
}

src_install() {
	cd "${CMAKE_BUILD_DIR}"
	insinto /usr/share/osm
	doins -r icons.* *.small *.big
	doins geoinfo.*
}
