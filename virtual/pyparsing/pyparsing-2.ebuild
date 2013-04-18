# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pyparsing/pyparsing-2.ebuild,v 1.3 2013/03/30 13:09:25 floppym Exp $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} pypy{1_8,1_9,2_0} )
inherit python-r1

DESCRIPTION="A virtual for pyparsing, for Python 2 & 3"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep \
		"dev-python/pyparsing:py2[$(python_gen_usedep 'python2*' 'pypy*')]" \
		python2* pypy*)
	$(python_gen_cond_dep \
		"dev-python/pyparsing:py3[$(python_gen_usedep 'python3*')]" \
		python3*)"
