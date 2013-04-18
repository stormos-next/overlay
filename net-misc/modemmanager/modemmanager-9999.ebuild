# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/modemmanager/modemmanager-9999.ebuild,v 1.2 2013/01/31 06:00:34 tetromino Exp $

EAPI="5"
GNOME_ORG_MODULE="ModemManager"

inherit autotools eutils git-2 gnome.org user multilib toolchain-funcs udev virtualx

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="http://cgit.freedesktop.org/ModemManager/ModemManager/"

LICENSE="GPL-2+"
SLOT="0/1" # subslot = dbus interface version, i.e. N in org.freedesktop.ModemManager${N}
KEYWORDS=
IUSE="doc policykit +qmi qmi-newest test"
REQUIRED_USE="qmi-newest? ( qmi )"
SRC_URI=
EGIT_REPO_URI="git://anongit.freedesktop.org/ModemManager/ModemManager"

RDEPEND=">=dev-libs/glib-2.30.2:2
	net-dialup/ppp
	>=virtual/udev-147[gudev]
	policykit? ( >=sys-auth/polkit-0.106 )
	qmi? ( net-libs/libqmi )
"
DEPEND="${RDEPEND}
	doc? (
		app-office/dia
		dev-libs/libxslt
		dev-util/gtk-doc )
	test? (
		dev-lang/python:2.7
		dev-python/dbus-python[python_targets_python2_7]
		dev-python/pygobject:2[python_targets_python2_7] )
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig

	dev-util/gtk-doc-am
"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	# Use python2.7 shebangs for test scripts
	sed -e 's@\(^#!.*python\)@\12.7@' \
		-i test/*.py || die

	epatch_user
	eautoreconf # for 9999
	default
}

src_configure() {
	# ppp-2.4.5 changes the plugin directory
	if has_version '=net-dialup/ppp-2.4.4*'; then
		pppd_plugin_dir="pppd/2.4.4"
	elif has_version '=net-dialup/ppp-2.4.5*'; then
		pppd_plugin_dir="pppd/2.4.5"
	fi

	econf \
		--disable-more-warnings \
		--with-udev-base-dir="$(udev_get_udevdir)" \
		--disable-static \
		--with-dist-version=${PVR} \
		--with-pppd-plugin-dir="/usr/$(get_libdir)/${pppd_plugin_dir}" \
		$(use_with doc docs) \
		$(use_with policykit polkit) \
		$(use_with qmi) \
		$(use_with qmi-newest newest-qmi-commands) \
		$(use_with test tests)
}

src_install() {
	default
	use doc && dohtml docs/spec.html

	# Allow users in plugdev group full control over their modem
	if use policykit; then
		insinto /usr/share/polkit-1/rules.d/
		doins "${FILESDIR}"/01-org.freedesktop.ModemManager.rules
	fi

	# Remove useless .la files
	prune_libtool_files --modules
}

pkg_postinst() {
	if use policykit; then
		enewgroup plugdev
		elog "To control your modem without needing to enter the root password,"
		elog "add your user account to the 'plugdev' group."
		elog
	fi

	# The polkit rules file moved to /usr/share
	old_rules="${EROOT}etc/polkit-1/rules.d/01-org.freedesktop.ModemManager.rules"
	if [[ -f "${old_rules}" ]]; then
		case "$(md5sum ${old_rules})" in
		  c5ff02532cb1da2c7545c3069e5d0992* | 5c50f0dc603c0a56e2851a5ce9389335* )
			# Automatically delete the old rules.d file if the user did not change it
			elog
			elog "Removing old ${old_rules} ..."
			rm -f "${old_rules}" || eerror "Failed, please remove ${old_rules} manually"
			;;
		  * )
			elog "The ${old_rules}"
			elog "file moved to /usr/share/polkit-1/rules.d/ in >=modemmanager-0.5.2.0-r2"
			elog "If you edited ${old_rules}"
			elog "without changing its behavior, you may want to remove it."
			;;
		esac
	fi

	elog "If your USB modem shows up as a Flash drive when you plug it in,"
	elog "You should install sys-apps/usb_modeswitch which will automatically"
	elog "switch it over to USB modem mode whenever you plug it in."
}
