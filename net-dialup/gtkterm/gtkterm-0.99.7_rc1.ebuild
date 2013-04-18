# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gtkterm/gtkterm-0.99.7_rc1.ebuild,v 1.2 2012/10/06 10:35:00 pacho Exp $

EAPI=4
inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="A serial port terminal written in GTK+, similar to Windows' HyperTerminal"
HOMEPAGE="https://fedorahosted.org/gtkterm/"
SRC_URI="https://fedorahosted.org/released/gtkterm/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

inherit eutils autotools

RDEPEND=">=x11-libs/gtk+-2.16:2
	>=x11-libs/vte-0.20:0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" fr hu"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

S=${WORKDIR}/${P/_/-}

src_prepare() {
	# Fix test
	echo "src/term_config.c" >> po/POTFILES.in || die

	epatch "${FILESDIR}/${P}-configure.patch"
	eautoreconf
}

src_install() {
	einstall || die "einstall failed"
	make_desktop_entry "${PN}"

	if use nls; then
		cd "${S}/po"
		local MY_LINGUAS="" lang

		for lang in ${MY_AVAILABLE_LINGUAS} ; do
			if use linguas_${lang} ; then
				MY_LINGUAS="${MY_LINGUAS} ${lang}"
			fi
		done
		if [[ "${MY_LINGUAS}" ]] ; then

			elog "Locale messages will be installed for following languages:"
			elog "   ${MY_LINGUAS}"

			for lang in ${MY_LINGUAS}; do
				msgfmt -o ${lang}.mo ${lang}.po && \
					insinto /usr/share/locale/${lang}/LC_MESSAGES && \
					newins ${lang}.mo gtkterm.mo || \
						die "failed to install locale messages for ${lang} language"
			done
		fi
	fi
}
