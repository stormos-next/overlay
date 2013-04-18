# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/noip-updater/noip-updater-2.1.9.ebuild,v 1.5 2008/12/22 20:29:54 armin76 Exp $

inherit eutils toolchain-funcs

MY_P=${P/-updater/}
DESCRIPTION="no-ip.com dynamic DNS updater"
HOMEPAGE="http://www.no-ip.com"
SRC_URI="http://www.no-ip.com/client/linux/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gcc"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/noip-2.1.9-flags.patch
	epatch "${FILESDIR}"/noip-2.1.9-daemon.patch
	sed -i \
		-e "s:\(#define CONFIG_FILEPATH\).*:\1 \"/etc\":" \
		-e "s:\(#define CONFIG_FILENAME\).*:\1 \"/etc/no-ip2.conf\":" \
		noip2.c || die "sed failed"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		PREFIX=/usr \
		CONFDIR=/etc || die "emake failed"
}

src_install() {
	dosbin noip2
	dodoc README.FIRST
	newinitd "${FILESDIR}"/noip2.start noip
}

pkg_postinst() {
	elog "Configuration can be done manually via:"
	elog "/usr/sbin/noip2 -C or "
	elog "first time you use the /etc/init.d/noip script; or"
	elog "by using this ebuild's config option."
}

pkg_config() {
	cd /tmp
	einfo "Answer the following questions."
	noip2 -C || die
}
