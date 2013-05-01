# Copyright (c) 2013 Andrew Stormont.  All rights reserved.

EAPI="5"
ETYPE="sources"
SLOT="0"

inherit git-2 eutils

KEYWORDS="~x86-solaris"
IUSE="multilib debug"

RDEPEND="dev-libs/libxml2[multilib?]
	dev-libs/openssl[multilib?]
	dev-libs/glib[multilib?]
	dev-libs/dbus-glib[multilib?]
	sys-libs/zlib[multilib?]
	sys-apps/dbus[multilib?]
	dev-libs/nspr[mulitlib?]
	dev-libs/nss[multilib?]
	app-crypt/trousers[multilib?]
	www-servers/apache-2[multilib?]"
DEPEND="${RDEPEND}
	dev-lang/python:2.6
	>=dev-lang/perl-5.10.0
	net-analyzer/net-snmp"

HOMEPAGE="http://illumos.org"
DESCRIPTION="illumos kernel with StormOS patchset"

EGIT_REPO_URI="git://github.com/illumos/illumos-gate.git"
SRC_URI="http://dlc.sun.com/osol/on/downloads/20100817/on-closed-bins.i386.tar.bz2
	http://dlc.sun.com/osol/on/downloads/20100817/on-closed-bins-nd.i386.tar.bz2"

src_prepare()
{
	epatch "${FILESDIR}/better-apache-compat.patch" || die
	epatch "${FILESDIR}/better-perl-compat.patch" || die
	epatch "${FILESDIR}/BUILD64_fixes.patch" || die
	epatch "${FILESDIR}/connect-socket-in-libc.patch" || die
	epatch "${FILESDIR}/egrep-q-option.patch" || die
	epatch "${FILESDIR}/ENABLE_PKCS11_ENGINE.patch" || die
	epatch "${FILESDIR}/find-path-option.patch" || die
	epatch "${FILESDIR}/gethostbyname2.patch" || die
	epatch "${FILESDIR}/grep-H-option.patch" || die
	epatch "${FILESDIR}/kmf_openssl_no_md2.patch" || die
	epatch "${FILESDIR}/ld-asneeded-verscript.patch" || die
	epatch "${FILESDIR}/libfmd_snmp-no-debugging.patch" || die
	epatch "${FILESDIR}/libicon-shim.patch" || die
	epatch "${FILESDIR}/nspr-nss-include-path.patch" || die
	epatch "${FILESDIR}/sun-logo-is-missing.patch" || die
}

src_configure()
{
	elog "Generating illumos.sh file"
	sed -e "s#^export GATE='.*'\$#export GATE=\"illumos-gate\"#g" \
		-e "s#^export CODEMGR_WS=\".*\"\$#export CODEMGR_WS=\"${S}\"#g" \
 		-e "s#^export VERSION=\".*\"\$#export VERSION=\"illumos-gate\"#g" \
 		-e "s#^export ON_CLOSED_BINS=\".*\"\$#export ON_CLOSED_BINS=\"${WORKDIR}/closed\"#g" \
 		usr/src/tools/env/illumos.sh > illumos.sh || die

	# FIXME: Our version of openssl does not support this yet
	echo "" >> illumos.sh
	echo "# Disable pkcs11 engine support" >> illumos.sh
	echo "export ENABLE_PKCS11_ENGINE='#'" >> illumos.sh

	if ! use multilib ; then
		elog "Disabling 64bit build (add multilib to USE to enable)"
		echo "" >> illumos.sh
		echo "# Disable 64bit build" >> illumos.sh
		echo "export BUILD64='#'" >> illumos.sh
	fi

	# Support for building with studio is broken upstream
	echo "" >> illumos.sh
	echo "# Force GCC only build" >> illumos.sh
	echo "export __SUNC='#'" >> illumos.sh
	echo "export __GNUC=''" >> illumos.sh

	elog "Running make setup"
	ksh usr/src/tools/scripts/bldenv.sh $(use debug && echo -d) -c illumos.sh \
		'cd usr/src && dmake setup' || die
}

src_compile()
{
	elog "Starting build.  This may take a while"
	ksh usr/src/tools/scripts/bldenv.sh $(use debug && echo -d) -c illumos.sh \
		'cd usr/src && dmake install' || die
}
