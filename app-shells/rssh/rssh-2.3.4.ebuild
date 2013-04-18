# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/rssh/rssh-2.3.4.ebuild,v 1.5 2013/01/05 21:35:40 pinkbyte Exp $

EAPI=4
inherit eutils multilib

DESCRIPTION="Restricted shell for SSHd"
HOMEPAGE="http://rssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/rssh/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static"

RDEPEND="virtual/ssh"

src_prepare() {
	sed -i 's:chmod u+s $(:chmod u+s $(DESTDIR)$(:' Makefile.in || die
	# respect CFLAGS, bug #450458
	sed -i -e '/$(CC) -c/s/$(CPPFLAGS)/$(CFLAGS)/' Makefile.in || die
}

src_configure() {
	econf \
		--libexecdir="/usr/$(get_libdir)/misc" \
		--with-scp=/usr/bin/scp \
		--with-sftp-server="/usr/$(get_libdir)/misc/sftp-server" \
		$(use_enable static)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog CHROOT INSTALL README TODO
}
