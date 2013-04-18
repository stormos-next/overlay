# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/hddtemp/hddtemp-0.3_beta15-r3.ebuild,v 1.12 2011/11/14 12:25:25 aidecoe Exp $

inherit eutils autotools

MY_P=${P/_beta/-beta}
DBV=20080531

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives"
HOMEPAGE="http://savannah.nongnu.org/projects/hddtemp/"
SRC_URI="http://download.savannah.gnu.org/releases/hddtemp/${MY_P}.tar.bz2 mirror://gentoo/hddtemp-${DBV}.db.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE="nls"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-satacmds.patch
	epatch "${FILESDIR}"/${P}-byteswap.patch
	epatch "${FILESDIR}"/${P}-execinfo.patch
	epatch "${FILESDIR}"/${P}-nls.patch
	epatch "${FILESDIR}"/${P}-iconv.patch
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	local myconf

	myconf="--with-db-path=/usr/share/hddtemp/hddtemp.db"
	# disabling nls breaks compiling
	use nls || myconf="--disable-nls ${myconf}"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README TODO ChangeLog

	insinto /usr/share/hddtemp
	newins "${WORKDIR}/hddtemp-${DBV}.db" hddtemp.db
	doins "${FILESDIR}"/hddgentoo.db

	update_db "${D}/usr/share/hddtemp/hddgentoo.db" "${D}/usr/share/hddtemp/hddtemp.db"
	newconfd "${FILESDIR}"/hddtemp-conf.d hddtemp
	newinitd "${FILESDIR}"/hddtemp-init hddtemp
}

pkg_postinst() {
	elog "In order to update your hddtemp database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog ""
	elog "If your hard drive is not recognized by hddtemp, please consider"
	elog "submitting your HDD info for inclusion into the Gentoo hddtemp"
	elog "database by filing a bug at https://bugs.gentoo.org/"
	elog ""
	elog "The hddtemp deamon requires a network interface to be up.  If you"
	elog "don't have an Ethernet interface, make sure at least the loopback"
	elog "interface is up by setting 'rc_depend_strict=\"NO\"' in /etc/rc.conf."
	echo
	ewarn "If hddtemp complains but finds your HDD temperature sensor, use the"
	ewarn "--quiet option to suppress the warning."
}

update_db() {
	local src=$1
	local dst=$2

	while read line ; do
		if [[ -z $(echo "${line}" | sed -re 's/(^#.*|^\w*$)//') ]]; then
			echo "${line}" >> "${dst}"
		fi

		id=$(echo "${line}" | grep -o '"[^"]*"')

		grep "${id}" "${dst}" 2>&1 >/dev/null || echo "${line}" >> "${dst}"
	done < "${src}"
}

pkg_config() {
	cd "${ROOT}"/usr/share/hddtemp

	einfo "Trying to download the latest hddtemp.db file"
	wget http://www.guzu.net/linux/hddtemp.db -O hddtemp.db \
		|| die "failed to download hddtemp.db"

	update_db "hddgentoo.db" "hddtemp.db"
}
