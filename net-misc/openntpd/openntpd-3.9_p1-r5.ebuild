# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openntpd/openntpd-3.9_p1-r5.ebuild,v 1.1 2012/12/16 21:47:51 ottxor Exp $

EAPI=5

inherit autotools eutils toolchain-funcs user

MY_P=${P/_/}
DEB_VER="8"
DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz
	mirror://debian/pool/main/o/openntpd/${MY_P/-/_}+debian-${DEB_VER}.debian.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ssl selinux"

RDEPEND="ssl? ( dev-libs/openssl )
	selinux? ( sec-policy/selinux-ntp )
	!<=net-misc/ntp-4.2.0-r2
	!net-misc/ntp[-openntpd]"
DEPEND="${RDEPEND}
	virtual/yacc"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ntp
	enewuser ntp -1 -1 /var/lib/openntpd/chroot ntp

	# make sure user has correct HOME when flipping between
	# the standard ntp pkg and this one
	usermod -d /var/lib/openntpd/chroot ntp
}

src_prepare() {
	sed -i '/NTPD_USER/s:_ntp:ntp:' ntpd.h || die

	epatch "${WORKDIR}"/debian/patches/*.patch
	sed -i 's:debian:gentoo:g' ntpd.conf || die
	eautoreconf # deb patchset touches .ac files and such
}

src_configure() {
	econf \
		--disable-strip \
		--with-adjtimex \
		$(use_with !ssl builtin-arc4random) \
		AR="$(type -p $(tc-getAR))"
}

src_install() {
	default

	newinitd "${FILESDIR}/openntpd.init.d-${PV}-r4" ntpd
	newconfd "${FILESDIR}/openntpd.conf.d-${PV}-r4" ntpd
}
