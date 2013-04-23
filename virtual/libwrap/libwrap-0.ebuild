# Copyright (c) 2013 Andrew Stormont.  All rights reserved.

DESCRIPTION="Virtual for the tcp-wrapper library"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="~x86-solaris"
IUSE="kernel_SunOS"
DEPEND=""

RDEPEND="!kernel_SunOS? ( sys-apps/tcp-wrapper )"
