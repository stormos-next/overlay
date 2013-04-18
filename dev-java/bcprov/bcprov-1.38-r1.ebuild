# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bcprov/bcprov-1.38-r1.ebuild,v 1.1 2010/03/28 21:30:35 caster Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-jdk14-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.3"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

# The src_unpack find needs a new find
# https://bugs.gentoo.org/show_bug.cgi?id=182276
DEPEND=">=virtual/jdk-1.4
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

IUSE="userland_GNU"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./src.zip

	# so that we don't need junit
	echo "Removing testcases' sources:"
	find . -path '*test/*.java' -print -delete \
		|| die "Failed to delete testcases."
	find . -name '*Test*.java' -print -delete \
		|| die "Failed to delete testcases."
}

src_compile() {
	mkdir "${S}/classes"

	find . -name "*.java" > "${T}/src.list"
	ejavac -encoding ISO-8859-1 -d "${S}/classes" "@${T}/src.list"

	cd "${S}/classes"
	jar -cf "${S}/${PN}.jar" * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar "${S}/${PN}.jar"

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
