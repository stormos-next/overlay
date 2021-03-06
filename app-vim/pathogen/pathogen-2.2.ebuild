# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/pathogen/pathogen-2.2.ebuild,v 1.1 2013/01/27 12:11:40 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: manage your runtimepath"
HOMEPAGE="https://github.com/tpope/vim-pathogen/ http://www.vim.org/scripts/script.php?script_id=2332"
SRC_URI="https://github.com/tpope/vim-pathogen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/vim-${P}
