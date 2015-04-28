# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools

DESCRIPTION="SFLphone is a robust, standards-compliant enterprise softphone, for desktop and embedded systems."
HOMEPAGE="http://sflphone.org/"
SRC_URI="mirror://sourceforge/slfphone/${P}.tar.gz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="v4l +presence ipv6 alsa pulseaudio jack +tls +zrtp dbus +im +sdes +gsm +speex +speexdsp +opus iax networkmanager"
REQUIRED_USE="
	speexdsp? ( speex )
	|| ( alsa pulseaudio jack )"

DEPEND="
	alsa?  ( >=media-libs/alsa-lib-1.0 )
	pulseaudio?
	       ( >=media-sound/pulseaudio-0.9.15 )
	jack?  ( media-sound/jack-audio-connection-kit )
	v4l? ( 
		virtual/libudev
		media-libs/libv4l
	)
	tls?   ( net-libs/gnutls )
	zrtp?  ( >=net-libs/libzrtpcpp-2.3.0 )
	dbus?  ( dev-libs/dbus-c++ )
	im?	   ( >=dev-libs/expat-2.0.0 )
	sdes?  ( dev-libs/libpcre )
	gsm?   ( media-sound/gsm )
	speex? ( media-libs/speex )
	opus?  ( media-libs/opus )
	networkmanager? 
		   ( net-misc/networkmanager )

	>=virtual/ffmpeg-9
	>=dev-libs/libyaml-0.1
	>=media-libs/libsamplerate-0.1.2
	media-libs/libsndfile
	>=net-libs/ccrtp-1.3.0
	dev-libs/openssl
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/daemon"

src_prepare() {
	sed -i -e 's/CXXFLAGS="-g/CXXFLAGS="-g $CXXFLAGS /' \
		configure.ac || die "sed failed."
	AT_NO_RECURSIVE="yes" eautoreconf
}

src_configure() {
	econf \
		$(use_enable v4l video) \
		$(use_enable presence) \
		$(use_enable ipv6) \
		$(use_with   alsa) \
		$(use_with   pulseaudio pulse) \
		$(use_with   jack) \
		$(use_with   tls ) \
		$(use_with   zrtp) \
		$(use_with   dbus) \
		$(use_with   im instant_messaging) \
		$(use_with   sdes) \
		$(use_with   gsm) \
		$(use_with   speex) \
		$(use_with   speexdsp) \
		$(use_with   opus) \
		$(use_with   iax iax2) \
		$(use_with   networkmanager) \
		--without-libilbc
}

src_compile() {
    cd ${S}/libs && ./compile_pjsip.sh

	cd ${S}
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
