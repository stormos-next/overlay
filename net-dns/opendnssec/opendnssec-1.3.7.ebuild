# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/opendnssec/opendnssec-1.3.7.ebuild,v 1.3 2012/07/11 23:44:53 mschiff Exp $

EAPI=4

MY_P="${P/_}"
PKCS11_IUSE="+softhsm opensc external-hsm"
inherit base autotools multilib user

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.${PN}.org/files/source/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="auditor +curl debug doc eppclient mysql +signer +sqlite test ${PKCS11_IUSE}"

RDEPEND="
	dev-lang/perl
	dev-libs/libxml2
	dev-libs/libxslt
	>=net-libs/ldns-1.6.12
	auditor? ( dev-lang/ruby[ssl] >=dev-ruby/dnsruby-1.53 )
	curl? ( net-misc/curl )
	mysql? (
		virtual/mysql
		dev-perl/DBD-mysql
	)
	opensc? ( dev-libs/opensc )
	softhsm? ( dev-libs/softhsm )
	sqlite? (
		dev-db/sqlite:3
		dev-perl/DBD-SQLite
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		app-text/trang
	)
"
# test? dev-util/cunit # Requires running test DB

REQUIRED_USE="
	^^ ( mysql sqlite )
	^^ ( softhsm opensc external-hsm )
	eppclient? ( curl )
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-localstatedir.patch"
	"${FILESDIR}/${PN}-drop-privileges.patch"
	"${FILESDIR}/${PN}-use-system-trang.patch"
)

S="${WORKDIR}/${MY_P}"

DOCS=( MIGRATION NEWS README )

check_pkcs11_setup() {
	# PKCS#11 HSM's are often only available with proprietary drivers not
	# available in portage tree.

	if use softhsm; then
		PKCS11_LIB=softhsm
		if has_version ">=dev-libs/softhsm-1.3.1"; then
			PKCS11_PATH=/usr/$(get_libdir)/softhsm/libsofthsm.so
		else
			PKCS11_PATH=/usr/$(get_libdir)/libsofthsm.so
		fi
		elog "Building with SoftHSM PKCS#11 library support."
	fi
	if use opensc; then
		PKCS11_LIB=opensc
		PKCS11_PATH=/usr/$(get_libdir)/opensc-pkcs11.so
		elog "Building with OpenSC PKCS#11 library support."
	fi
	if use external-hsm; then
		if [[ -n ${PKCS11_SCA6000} ]]; then
			PKCS11_LIB=sca6000
			PKCS11_PATH=${PKCS11_SCA6000}
		elif [[ -n ${PKCS11_ETOKEN} ]]; then
			PKCS11_LIB=etoken
			PKCS11_PATH=${PKCS11_ETOKEN}
		elif [[ -n ${PKCS11_NCIPHER} ]]; then
			PKCS11_LIB=ncipher
			PKCS11_PATH=${PKCS11_NCIPHER}
		elif [[ -n ${PKCS11_AEPKEYPER} ]]; then
			PKCS11_LIB=aepkeyper
			PKCS11_PATH=${PKCS11_AEPKEYPER}
		else
			ewarn "You enabled USE flag 'external-hsm' but did not specify a path to a PKCS#11"
			ewarn "library. To set a path, set one of the following environment variables:"
			ewarn "  for Sun Crypto Accelerator 6000, set: PKCS11_SCA6000=<path>"
			ewarn "  for Aladdin eToken, set: PKCS11_ETOKEN=<path>"
			ewarn "  for Thales/nCipher netHSM, set: PKCS11_NCIPHER=<path>"
			ewarn "  for AEP Keyper, set: PKCS11_AEPKEYPER=<path>"
			ewarn "Example:"
			ewarn "  PKCS11_ETOKEN=\"/opt/etoken/lib/libeTPkcs11.so\" emerge -pv opendnssec"
			ewarn "or store the variable into /etc/make.conf"
			die "USE flag 'external-hsm' set but no PKCS#11 library path specified."
		fi
		elog "Building with external PKCS#11 library support ($PKCS11_LIB): ${PKCS11_PATH}"
	fi
}

pkg_pretend() {
	local i

	for i in eppclient mysql; do
		if use ${i}; then
			ewarn "Usage of ${i} is considered experimental."
			ewarn "Do not report bugs against this feature."
		fi
	done

	check_pkcs11_setup
}

pkg_setup() {
	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec

	# pretend does not preserve variables so we need to run this once more
	check_pkcs11_setup
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	# $(use_with test cunit "${EPREFIX}/usr/") \
	econf \
		--without-cunit \
		--localstatedir="${EPREFIX}/var/" \
		--disable-static \
		--with-database-backend=$(use mysql && echo "mysql")$(use sqlite && echo "sqlite3") \
		--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH} \
		$(use_with curl) \
		$(use_enable auditor) \
		$(use_enable debug timeshift) \
		$(use_enable eppclient) \
		$(use_enable signer)
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default

	# remove useless .la files
	find "${ED}" -name '*.la' -delete

	# Remove subversion tags from config files to avoid useless config updates
	sed -i \
		-e '/<!-- \$Id:/ d' \
		"${ED}"/etc/opendnssec/* || die

	# install update scripts
	insinto /usr/share/opendnssec
	use sqlite && doins enforcer/utils/migrate_keyshare_sqlite3.pl
	use mysql && doins enforcer/utils/migrate_keyshare_mysql.pl

	# fix permissions
	fowners root:opendnssec /etc/opendnssec
	fowners root:opendnssec /etc/opendnssec/{conf,kasp,zonelist,zonefetch}.xml
	use eppclient && fowners root:opendnssec /etc/opendnssec/eppclientd.conf

	fowners opendnssec:opendnssec /var/lib/opendnssec/{,signconf,unsigned,signed,tmp}
	fowners opendnssec:opendnssec /var/run/opendnssec

	# install conf/init script
	newinitd "${FILESDIR}"/opendnssec.initd opendnssec
	newconfd "${FILESDIR}"/opendnssec.confd opendnssec
}

pkg_postinst() {
	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location writeable"
		elog "by the opendnssec user. You can set its location in /etc/softhsm.conf."
		elog "Suggested configuration is:"
		elog "    echo \"0:/var/lib/opendnssec/softhsm_slot0.db\" >> /etc/softhsm.conf"
		elog "    softhsm --init-token --slot 0 --label OpenDNSSEC"
		elog "    chown opendnssec:opendnssec /var/lib/opendnssec/softhsm_slot0.db"
	fi

	# caution if upgrading to 1.3.7
	if [[ -d /var/lib/opencryptoki ]]; then
		ewarn
		ewarn "WARNING:"
		ewarn "It seems that you have dev-libs/opencryptoki installed."
		ewarn "If you are using a Sun Crypto Accelerator 6000 (SCA/6000):"
		ewarn
		ewarn "Press Ctrl-C now and read the following upstream message"
		ewarn "carefully before you continue:"
		ewarn
		ewarn "HSM SCA 6000 in combination with OpenCryptoki can return RSA key"
		ewarn "material with leading zeroes. DNSSEC does not allow leading zeroes"
		ewarn "in key data. You are affected by this bug if your DNSKEY RDATA e.g."
		ewarn "begins with 'BAABA'."
		ewarn "Normal keys begin with e.g. 'AwEAA'."
		ewarn "OpenDNSSEC will now sanitize incoming data before adding it to the"
		ewarn "DNSKEY. Do not upgrade to this version if you are affected by the bug."
		ewarn "You first need to go unsigned, then do the upgrade, and finally sign"
		ewarn "your zone again. SoftHSM and other HSM:s will not produce data with"
		ewarn "leading zeroes and the bug will thus not affect you."
		ewarn
		echo -n " * "
		for i in {10..1}; do echo -n "$i "; sleep 1; done
		echo
	fi
}
