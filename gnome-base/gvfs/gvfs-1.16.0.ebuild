# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gvfs/gvfs-1.16.0.ebuild,v 1.4 2013/04/07 09:43:07 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools bash-completion-r1 eutils gnome2

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x86-solaris"
DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README TODO" # ChangeLog.pre-1.2 README.commits

SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~tetromino/distfiles/aclocal/libgcrypt.m4.bz2"

IUSE="afp archive avahi bluetooth bluray cdda doc fuse gdu gnome-keyring gnome-online-accounts gphoto2 gtk +http mtp ios samba systemd +udev udisks"
REQUIRED_USE="systemd? ( udisks )"

# Can use libgphoto-2.5.0 as well. Automagic detection.
RDEPEND=">=dev-libs/glib-2.35:2
	sys-apps/dbus
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:= )
	archive? ( app-arch/libarchive:= )
	avahi? ( >=net-dns/avahi-0.6 )
	bluetooth? (
		>=app-mobilephone/obex-data-server-0.4.5
		dev-libs/dbus-glib
		net-wireless/bluez
		dev-libs/expat )
	bluray? ( media-libs/libbluray )
	fuse? ( >=sys-fs/fuse-2.8.0 )
	gdu? ( || (
		>=gnome-base/libgdu-3.0.2
		=sys-apps/gnome-disk-utility-3.0.2-r300
		=sys-apps/gnome-disk-utility-3.0.2-r200 ) )
	gnome-keyring? ( app-crypt/libsecret )
	gphoto2? ( >=media-libs/libgphoto2-2.4.7:= )
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	http? ( || ( >=net-libs/libsoup-2.42:2.4 >=net-libs/libsoup-gnome-2.34.0[gnome] ) )
	ios? (
		>=app-pda/libimobiledevice-1.1.0
		>=app-pda/libplist-1 )
	mtp? ( >=media-libs/libmtp-1.1.5 )
	samba? ( >=net-fs/samba-3.4.6[smbclient] )
	systemd? ( sys-apps/systemd )
	udev? (
		cdda? ( || ( dev-libs/libcdio-paranoia <dev-libs/libcdio-0.90[-minimal] ) )
		virtual/udev[gudev] )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1 )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

REQUIRED_USE="cdda? ( udev )"

src_prepare() {
	if use archive; then
		epatch "${FILESDIR}"/${PN}-1.16.0-expose-archive-backend.patch
		echo mount-archive.desktop.in >> po/POTFILES.in
		echo mount-archive.desktop.in.in >> po/POTFILES.in
	fi

	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die
	fi

	if use archive || ! use udev; then
		# libgcrypt.m4 needed for eautoreconf, bug #399043
		mv "${WORKDIR}/libgcrypt.m4" "${S}"/ || die
		AT_M4DIR=. eautoreconf
	fi

	gnome2_src_prepare
}

src_configure() {
	# --enable-documentation installs man pages
	G2CONF="${G2CONF}
		--disable-bash-completion
		--disable-hal
		--with-dbus-service-dir="${EPREFIX}"/usr/share/dbus-1/services
		--enable-documentation
		$(use_enable afp)
		$(use_enable archive)
		$(use_enable avahi)
		$(use_enable bluetooth obexftp)
		$(use_enable bluray)
		$(use_enable cdda)
		$(use_enable doc gtk-doc)
		$(use_enable fuse)
		$(use_enable gdu)
		$(use_enable gphoto2)
		$(use_enable gtk)
		$(use_enable ios afc)
		$(use_enable mtp libmtp)
		$(use_enable udev)
		$(use_enable udev gudev)
		$(use_enable http)
		$(use_enable gnome-keyring keyring)
		$(use_enable samba)
		$(use_enable systemd libsystemd-login)
		$(use_enable udisks udisks2)"
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
	dobashcomp programs/completion/gvfs
}
