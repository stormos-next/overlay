# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/concurrent-util/concurrent-util-1.3.4-r1.ebuild,v 1.11 2013/04/16 18:44:53 ulm Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Utility classes commonly encountered in concurrent Java programming."
HOMEPAGE="http://gee.cs.oswego.edu/dl/classes/EDU/oswego/cs/dl/util/concurrent/intro.html"
SRC_URI="mirror://gentoo/gentoo-concurrent-util-1.3.4.tar.bz2"

LICENSE="public-domain sun-concurrent-util MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=virtual/jre-1.2"
DEPEND=">=virtual/jdk-1.2"

EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_dojar build/lib/concurrent.jar
	use source && java-pkg_dosrc src/java/*

	if use doc ; then
		cd build
		java-pkg_dojavadoc javadoc
		insinto /usr/share/doc/${PF}/demo
		doins demo/*
	fi
}
