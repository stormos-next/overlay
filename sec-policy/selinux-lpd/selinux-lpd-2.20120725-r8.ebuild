# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-lpd/selinux-lpd-2.20120725-r8.ebuild,v 1.2 2012/12/13 10:04:52 swift Exp $
EAPI="4"

IUSE=""
MODS="lpd"
BASEPOL="2.20120725-r8"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for lpd"

KEYWORDS="amd64 x86"
