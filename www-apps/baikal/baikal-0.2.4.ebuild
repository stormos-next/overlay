# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/baikal/baikal-0.2.4.ebuild,v 1.1 2013/03/12 18:43:40 grobian Exp $

EAPI="5"

inherit depend.php webapp

DESCRIPTION="Lightweight CalDAV+CardDAV server"
HOMEPAGE="http://baikal-server.com/"
SRC_URI="http://baikal-server.com/get/${PN}-regular-${PV}.tgz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

RDEPEND=">=dev-lang/php-5.3[pdo,xml,mysql?,sqlite?]
	mysql? ( dev-db/mysql )
	sqlite? ( dev-db/sqlite )
	virtual/httpd-php"

need_php5
need_httpd

S=${WORKDIR}/${PN}-regular

src_install() {
	webapp_src_preinst

	dodoc-php *.md  || die "dodoc failed"

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r html/* html/.htaccess Core || die "doins failed"

	einfo "Setting up container for configuration"
	insinto /etc/${PN}
	doins Specific/.htaccess || die "doins failed"

	einfo "Fixing symlinks"
	local link target
	find "${D}${MY_HTDOCSDIR}" -type l | while read link ; do
		target=$(readlink "${link}")
		target=${target/..\/Core/Core}
		rm "${link}" && ln -s "${target}" "${link}"
	done
	dosym /etc/${PN} "${MY_HTDOCSDIR}"/Specific
	dosym . "${MY_HTDOCSDIR}"/html

	webapp_src_install

	fowners -R apache:apache /etc/${PN}
}

pkg_postinst() {
	einfo "In order to setup baïkal:"
	einfo "- create /etc/${PN}/ENABLE_INSTALL owner apache:apache"
	einfo "- point your browser at the instal's URL and follow the setup"
}
