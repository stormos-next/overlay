# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/vc/vc-1.41.ebuild,v 1.4 2007/07/11 02:37:38 mr_bones_ Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Version Control for Free systems."
PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/ediff
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
