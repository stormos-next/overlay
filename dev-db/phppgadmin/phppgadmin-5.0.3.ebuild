# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/phppgadmin/phppgadmin-5.0.3.ebuild,v 1.5 2011/10/09 17:46:09 xarthisius Exp $

EAPI="4"

inherit webapp

MY_P="phpPgAdmin-${PV}"

DESCRIPTION="Web-based administration for Postgres database in php"
HOMEPAGE="http://phppgadmin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="dev-lang/php[postgres,session]
	|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"

S="${WORKDIR}/${MY_P}"

src_install() {
	webapp_src_preinst

	local doc
	local docs="CREDITS DEVELOPERS FAQ HISTORY INSTALL TODO TRANSLATORS"
	dodoc ${docs}
	mv conf/config.inc.php-dist conf/config.inc.php

	cp -r * "${D}"${MY_HTDOCSDIR}
	for doc in ${docs} INSTALL LICENSE; do
		rm -f "${D}"${MY_HTDOCSDIR}/${doc}
	done

	webapp_configfile ${MY_HTDOCSDIR}/conf/config.inc.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
