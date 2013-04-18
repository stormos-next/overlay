# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/iotop/iotop-0.5.ebuild,v 1.1 2013/02/04 07:51:08 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} pypy{1_9,2_0} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 linux-info

DESCRIPTION="Top-like UI used to show which process is using the I/O"
HOMEPAGE="http://guichaz.free.fr/iotop/"
SRC_URI="http://guichaz.free.fr/iotop//files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS ~VM_EVENT_COUNTERS"
DOCS=( NEWS README THANKS ChangeLog )

pkg_setup() {
	linux-info_pkg_setup
}
