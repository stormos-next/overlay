# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.4.0.ebuild,v 1.5 2013/04/05 10:42:16 scarabeus Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_2 python3_3 )

EGIT_REPO_URI="git://git.sv.gnu.org/weechat.git"
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"
inherit eutils python-single-r1 multilib cmake-utils ${GIT_ECLASS}

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.org/"
[[ ${PV} == "9999" ]] || SRC_URI="http://${PN}.org/files/src/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

NETWORKS="+irc"
PLUGINS="+alias +charset +fifo +logger +relay +rmodifier +scripts +spell +xfer"
#INTERFACES="+ncurses gtk"
SCRIPT_LANGS="guile lua +perl +python ruby tcl"
IUSE="${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS} +crypt doc nls +ssl"

RDEPEND="
	net-misc/curl[ssl]
	sys-libs/ncurses
	charset? ( virtual/libiconv )
	guile? ( dev-scheme/guile )
	irc? ( dev-libs/libgcrypt )
	lua? ( dev-lang/lua[deprecated] )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	ruby? ( >=dev-lang/ruby-1.9 )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15 )
"
#	ncurses? ( sys-libs/ncurses )
#	gtk? ( x11-libs/gtk+:2 )
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.15 )
"

DOCS="AUTHORS ChangeLog NEWS README"

#REQUIRED_USE=" || ( ncurses gtk )"

LANGS=( cs de es fr hu it ja pl pt_BR ru )
for X in "${LANGS[@]}" ; do
	IUSE="${IUSE} linguas_${X}"
done

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	local i

	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		CMakeLists.txt || die "sed failed"

	# install only required translations
	for i in "${LANGS[@]}" ; do
		if ! use linguas_${i} ; then
			sed -i \
				-e "/${i}.po/d" \
				po/CMakeLists.txt || die
		fi
	done

	epatch "${FILESDIR}/${PN}-icon.patch"
}

# alias, rmodifier, xfer
src_configure() {
	# $(cmake-utils_use_enable gtk)
	# $(cmake-utils_use_enable ncurses)
	local mycmakeargs=(
		"-DENABLE_NCURSES=ON"
		"-DENABLE_LARGEFILE=ON"
		"-DENABLE_DEMO=OFF"
		"-DENABLE_GTK=OFF"
		"-DPYTHON_EXECUTABLE=${PYTHON}"
		$(cmake-utils_use_enable nls)
		$(cmake-utils_use_enable crypt GCRYPT)
		$(cmake-utils_use_enable spell ASPELL)
		$(cmake-utils_use_enable charset)
		$(cmake-utils_use_enable fifo)
		$(cmake-utils_use_enable irc)
		$(cmake-utils_use_enable logger)
		$(cmake-utils_use_enable relay)
		$(cmake-utils_use_enable scripts)
		$(cmake-utils_use_enable scripts script)
		$(cmake-utils_use_enable perl)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable ruby)
		$(cmake-utils_use_enable lua)
		$(cmake-utils_use_enable tcl)
		$(cmake-utils_use_enable guile)
		$(cmake-utils_use_enable doc)
	)

	cmake-utils_src_configure
}
