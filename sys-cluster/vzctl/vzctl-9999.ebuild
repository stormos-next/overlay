# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/vzctl/vzctl-9999.ebuild,v 1.14 2013/02/22 14:24:39 pinkbyte Exp $

EAPI="5"

inherit bash-completion-r1 autotools git-2 toolchain-funcs udev

DESCRIPTION="OpenVZ ConTainers control utility"
HOMEPAGE="http://openvz.org/"
EGIT_REPO_URI="git://git.openvz.org/pub/${PN}
	http://git.openvz.org/pub/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cgroup +ploop"

RDEPEND="
	net-firewall/iptables
	sys-apps/ed
	>=sys-apps/iproute2-3.3.0
	sys-fs/vzquota
	ploop? ( >=sys-cluster/ploop-1.5 )
	cgroup? ( >=dev-libs/libcgroup-0.37 )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Set default OSTEMPLATE on gentoo
	sed -i -e 's:=redhat-:=gentoo-:' etc/dists/default || die 'sed on etc/dists/default failed'
	# Set proper udev directory
	sed -i -e "s:/lib/udev:$(udev_get_udevdir):" src/lib/dev.c || die 'sed on src/lib/dev.c failed'
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-udev \
		--enable-bashcomp \
		--enable-logrotate \
		$(use_with ploop) \
		$(use_with cgroup)
}

src_install() {
	emake DESTDIR="${D}" udevdir="$(udev_get_udevdir)"/rules.d install install-gentoo

	# install the bash-completion script into the right location
	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp etc/bash_completion.d/vzctl.sh ${PN}

	# We need to keep some dirs
	keepdir /vz/{dump,lock,root,private,template/cache}
	keepdir /etc/vz/names /var/lib/vzctl/veip
}

pkg_postinst() {
	ewarn "To avoid loosing network to CTs on iface down/up, please, add the"
	ewarn "following code to /etc/conf.d/net:"
	ewarn " postup() {"
	ewarn "     /usr/sbin/vzifup-post \${IFACE}"
	ewarn " }"

	ewarn "Starting with 3.0.25 there is new vzeventd service to reboot CTs."
	ewarn "Please, drop /usr/share/vzctl/scripts/vpsnetclean and"
	ewarn "/usr/share/vzctl/scripts/vpsreboot from crontab and use"
	ewarn "/etc/init.d/vzeventd."

	if use cgroup; then
		ewarn "You have chose to use experimental CGROUP feature"
		ewarn "please do NOT file bugs to Gentoo bugzilla,"
		ewarn "use upstream bug tracker instead"
	fi
}
