# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-eyes-plugin/xfce4-eyes-plugin-4.4.1-r1.ebuild,v 1.8 2012/11/28 12:26:23 ssuominen Exp $

EAPI=5
EAUTORECONF=yes
inherit multilib xfconf

DESCRIPTION="A panel plug-in which adds classic eyes to your every step"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-eyes-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-libxfce4ui.patch )

	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
