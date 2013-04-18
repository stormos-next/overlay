# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Sys-Syslog/Sys-Syslog-0.290.0.ebuild,v 1.12 2012/05/09 15:27:43 aballier Exp $

EAPI=4

MODULE_AUTHOR=SAPER
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="Provides same functionality as BSD syslog"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Tests disabled - they attempt to verify on the live system
#SRC_TEST="do"
