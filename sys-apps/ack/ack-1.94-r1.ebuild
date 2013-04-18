# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ack/ack-1.94-r1.ebuild,v 1.3 2011/10/27 15:08:01 chainsaw Exp $

EAPI=3

ACK_PATCH="ack-gentoo-r1.patch"

MODULE_AUTHOR=PETDANCE
inherit perl-module bash-completion

DESCRIPTION="ack is a tool like grep, aimed at programmers with large trees of heterogeneous source code"
HOMEPAGE="http://betterthangrep.com/ ${HOMEPAGE}"
SRC_URI+=" http://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/${ACK_PATCH}.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=">=dev-perl/File-Next-1.02"
RDEPEND="${DEPEND}"

SRC_TEST=do
PATCHES=( "${WORKDIR}"/${ACK_PATCH} )

src_install() {
	perl-module_src_install
	dobashcompletion etc/ack.bash_completion.sh
}

pkg_postinst() {
	bash-completion_pkg_postinst
}
