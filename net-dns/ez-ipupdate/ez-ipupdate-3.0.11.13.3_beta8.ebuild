# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ez-ipupdate/ez-ipupdate-3.0.11.13.3_beta8.ebuild,v 1.2 2012/06/14 02:09:47 zmedico Exp $

EAPI="2"

inherit eutils user versionator

MY_BETA="$(get_version_component_range 6)"
MY_PATCH="$(get_version_component_range 4-5)"
MY_PV="$(get_version_component_range 1-3)${MY_BETA/beta/b}"

DESCRIPTION="Dynamic DNS client for lots of dynamic dns services"
HOMEPAGE="http://ez-ipupdate.com/"
SRC_URI="mirror://debian/pool/main/e/ez-ipupdate/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/e/ez-ipupdate/${PN}_${MY_PV}-${MY_PATCH}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# apply debian patches
	epatch "${WORKDIR}/${PN}_${MY_PV}-${MY_PATCH}.diff"

	# repair/apply additional debian patches
	sed -i -e "s|^\(---\s*\)\.\./|\1|g" debian/patches/*.diff
	EPATCH_SOURCE="${S}/debian/patches" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch

	# adding members.3322.org support
	epatch "${FILESDIR}/${P}-3322.diff"

	# adding www.dnsexit.com support
	epatch "${FILESDIR}/${P}-dnsexit.diff"

	# make ez-ipupdate work with iproute2/dhcpcd under linux (bug #318905)
	epatch "${FILESDIR}/${P}-linux.diff"

	# repair format mask issues
	sed -i -e "s|\(\s*\)\(strlen(putbuf)\)|\1(int)\2|g" ez-ipupdate.c

	# comment out obsolete options
	sed -i -e "s:^\(run-as-user.*\):#\1:g" \
		-e "s:^\(cache-file.*\):#\1:g" ex*conf

	# make 'missing' executable (bug #103480)
	chmod +x missing
}

src_configure() {
	econf --bindir=/usr/sbin || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}/ez-ipupdate.initd" ez-ipupdate
	keepdir /etc/ez-ipupdate /var/cache/ez-ipupdate

	# install docs
	dodoc README
	newdoc debian/README.Debian README.debian
	newdoc debian/changelog ChangeLog.debian
	newdoc CHANGELOG ChangeLog
	doman debian/ez-ipupdate.8

	# install example configs
	docinto examples
	dodoc ex*conf
}

pkg_preinst() {
	enewgroup ez-ipupd
	enewuser ez-ipupd -1 -1 /var/cache/ez-ipupdate ez-ipupd
}

pkg_postinst() {
	chmod 750 /etc/ez-ipupdate /var/cache/ez-ipupdate
	chown ez-ipupd:ez-ipupd /etc/ez-ipupdate /var/cache/ez-ipupdate

	elog
	elog "Please create one or more config files in"
	elog "/etc/ez-ipupdate/. A bunch of samples can"
	elog "be found in the doc directory."
	elog
	elog "All config files must have a '.conf' extension."
	elog
	elog "Please do not use the 'run-as-user', 'run-as-euser',"
	elog "'cache-file' and 'pidfile' options, since these are"
	elog "handled internally by the init-script!"
	elog
	elog "If you want to use ez-ipupdate in daemon mode,"
	elog "please add 'daemon' to the config file(s) and"
	elog "add the ez-ipupdate init-script to the default"
	elog "runlevel."
	elog
	elog "Without the 'daemon' option, you can run the"
	elog "init-script with the 'update' parameter inside"
	elog "your PPP ip-up script."
	elog

	if [ -f /etc/ez-ipupdate.conf ]; then
		elog "!!! IMPORTANT UPDATE NOTICE !!!"
		elog
		elog "The ez-ipupdate init-script can now handle more"
		elog "than one config file. New config file location is"
		elog "/etc/ez-ipupdate/*.conf"
		elog
		if [ ! -f /etc/ez-ipupdate/default.conf ]; then
			mv -f /etc/ez-ipupdate.conf /etc/ez-ipupdate/default.conf
			elog "Your old configuration has been moved to"
			elog "/etc/ez-ipupdate/default.conf"
			elog
		fi
	fi
}
