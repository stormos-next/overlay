# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.5.2.ebuild,v 1.7 2012/11/25 09:32:49 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="A command line CD encoder"
HOMEPAGE="http://code.google.com/p/abcde/"
SRC_URI="http://abcde.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="aac cdparanoia flac id3tag lame musicbrainz normalize replaygain speex vorbis"

# See `grep :: abcde-musicbrainz-tool` output for USE musicbrainz dependencies.
RDEPEND="media-sound/cd-discid
	net-misc/wget
	virtual/eject
	aac? (
		media-libs/faac
		media-video/atomicparsley
		)
	cdparanoia? ( media-sound/cdparanoia )
	flac? ( media-libs/flac )
	id3tag? (
		>=media-sound/id3-0.12
		media-sound/id3v2
		)
	lame? ( media-sound/lame )
	musicbrainz? (
		dev-perl/MusicBrainz-DiscID
		dev-perl/WebService-MusicBrainz
		perl-core/Digest-SHA
		virtual/perl-Getopt-Long
		)
	normalize? ( >=media-sound/normalize-0.7.4 )
	replaygain? (
		vorbis? ( media-sound/vorbisgain )
		lame? ( media-sound/mp3gain )
		)
	speex? ( media-libs/speex )
	vorbis? ( media-sound/vorbis-tools )"

src_prepare() {
	epatch "${FILESDIR}"/m4a-tagging.patch
	sed -i -e 's:/etc/abcde.conf:/etc/abcde/abcde.conf:g' abcde || die
}

src_install() {
	emake DESTDIR="${D}" etcdir="${D}etc/abcde" install
	dodoc changelog FAQ README TODO USEPIPES
	docinto examples
	dodoc examples/*
}
