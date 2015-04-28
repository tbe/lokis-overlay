# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KDE_LINGUAS="bs ca cs da de es et fi fr ga gl hu it ja lt mr nl pl pt pt_BR ru sk sv tr ug uk zh_CN zh_HK"
OPENGL_REQUIRED="always"


inherit eutils cmake-utils kde4-base

P_PARENT="${PN%-kde}-${PV}"

DESCRIPTION="KDE UI for slfphone"
HOMEPAGE="http://sflphone.org/"
SRC_URI="mirror://sourceforge/slfphone/${P_PARENT}.tar.gz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="v4l"

DEPEND="
	$( add_kdebase_dep kdepimlibs )
	=net-voip/sflphone-${PVR}[v4l=,dbus]
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P_PARENT}/kde"
BUILD_DIR="${S}/build"

src_configure() {
	local mycmakeargs=(
	 	"-DENABLE_VIDEO=$( use v4l && echo "true" || echo "false" )"
	)
	kde4-base_src_configure
}
