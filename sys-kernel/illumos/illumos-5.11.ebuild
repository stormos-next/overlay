# Copyright (c) 2013 Andrew Stormont.  All rights reserved.

EAPI="5"
ETYPE="sources"
SLOT="0"

inherit git-2 eutils

KEYWORDS="~x86-solaris"
IUSE="multilib debug"

RDEPEND="dev-libs/libxml2
	dev-libs/openssl[multilib?]
	dev-libs/glib
	dev-libs/dbus-glib
	sys-libs/zlib[multilib?]
	sys-apps/dbus[multilib?]
	dev-libs/nspr[multilib?]
	dev-libs/nss[multilib?]
	app-crypt/trousers[multilib?]
	www-servers/apache:2[multilib?]"
DEPEND="${RDEPEND}
	dev-lang/python:2.6
	>=dev-lang/perl-5.10.0
	net-analyzer/net-snmp"

HOMEPAGE="http://illumos.org"
DESCRIPTION="illumos kernel with StormOS patchset"

EGIT_REPO_URI="git://github.com/stormos-next/illumos-stormos.git"
SRC_URI="http://dlc.sun.com/osol/on/downloads/20100817/on-closed-bins.i386.tar.bz2
	http://dlc.sun.com/osol/on/downloads/20100817/on-closed-bins-nd.i386.tar.bz2"

# We have yet to formally define illumos-stormos releases
#EGIT_COMMIT="aad02571bc59671aa3103bb070ae365f531b0b62"

src_prepare()
{
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/better-apache-compat.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/better-openssl-compat.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/better-perl-compat.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/better-uuid-compat.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/BUILD64_fixes.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/egrep-Hq-options.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/fix-cpp-path.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/fix-krb5-typo.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/flex-path.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/grep-H-option.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/ld-asneeded-verscript.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/libfmd_snmp-no-debugging.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/no-gnu-gettext.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/nspr-nss-include-path.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/revert-accept4-changes.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/rm-v-option.patch" || die
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/socket-symbols-in-libc.patch" || die	
	EPATCH_OPTS="-p1" epatch "${FILESDIR}/use-gnu-demangle.patch" || die
}

src_configure()
{
	elog "Generating illumos.sh file"
	sed -e "s:^export GATE='.*'\$:export GATE=\"illumos-gate\":g" \
		-e "s:^export CODEMGR_WS=\".*\"\$:export CODEMGR_WS=\"${S}\":g" \
 		-e "s:^export VERSION=\".*\"\$:export VERSION=\"illumos-gate\":g" \
 		-e "s:^export ON_CLOSED_BINS=\".*\"\$:export ON_CLOSED_BINS=\"${WORKDIR}/closed\":g" \
		-e "s:^# \(export ENABLE_SMB_PRINTING='#'\):\1:g" \
 		usr/src/tools/env/illumos.sh > illumos.sh || die

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
}

src_compile()
{
	# Keep some variables local so they don't interfere with the illumos build
	export -n ED
	export -n MAKE
	export -n INSTALL
	export -n CC
	export -n CXX
	export -n CFLAGS
	export -n CXXFLAGS
	export -n CPPFLAGS
	export -n LDFLAGS

	# Check there is enough RAM installed to fully utilise available CPUs
	if [ `prtconf | grep Memory | awk '{ print $3 }'` -lt 2048 ]; then
		ewarn "You have less than 2048Mb of memory installed"
		ewarn "This will cause your build to be throttled"
		ewarn "For better build times - install more RAM"
	fi
	
	elog "Running make setup"
	ksh usr/src/tools/scripts/bldenv.sh $(use debug && echo -d) -c illumos.sh \
		'cd usr/src && dmake setup' || die

	elog "Starting build.  This may take a while"
	ksh usr/src/tools/scripts/bldenv.sh $(use debug && echo -d) -c illumos.sh \
		'cd usr/src && dmake install' || die
}

src_install()
{
	# Install the kernel bits.  We can do this because we're not running on
	# a live system yet.  TODO: Check that is is actually true.
	for dir in kernel platform ; do
		cp -R "${S}/proto/root_i386/$dir" "${D}" || die
	done

	# Unmount libc so that it can be replaced.
	umount /lib/libc.so.1 2>/dev/null

	# Install everything else except for /dev /devices /proc - those belong
	# to the host system so clobbering them would not be a good idea.
	for dir in bin boot etc export home lib mnt opt root sbin usr var ; do
		cp -R "${S}/proto/root_i386/$dir" "${D}" || die
	done

	# Make xpg4 (e)grep the default
	for bin in grep egrep ; do
		ln -f "${D}/usr/xpg4/bin/$bin" "${D}/usr/bin/$bin" || die
	done

	# Drop uncompress/zcat.  We want to use sys/gzip version instead
	rm -f "${D}/usr/bin/{uncompress,zcat}" || die
	rm -f "${D}/usr/share/man/man1/{uncompress,zcat}.1" || die

	# Drop file.  We want to use sys-apps/file version instead
	rm -f "${D}/usr/bin/file" "${D}/etc/magic" || die
	rm -f "${D}/usr/share/man/man1/file.1" || die
	rm -f "${D}/usr/share/man/man4/magic.4" || die
}
