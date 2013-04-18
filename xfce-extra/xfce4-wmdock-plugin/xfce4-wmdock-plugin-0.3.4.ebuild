# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-wmdock-plugin/xfce4-wmdock-plugin-0.3.4.ebuild,v 1.7 2012/11/28 12:44:47 ssuominen Exp $

EAPI=5
inherit multilib xfconf

DESCRIPTION="a compatibility layer for running WindowMaker dockapps on Xfce4."
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-wmdock-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8
	>=x11-libs/libwnck-2.8.1:1"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog README TODO )
}

src_prepare() {
	echo panel-plugin/wmdock.desktop.in.in >> po/POTFILES.skip
	xfconf_src_prepare
}
