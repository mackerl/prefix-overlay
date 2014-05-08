# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-3.8.1.ebuild,v 1.1 2014/03/08 14:12:30 gienah Exp $

EAPI=2

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils toolchain-funcs 

DESCRIPTION="Open source software for numerical computation"
LICENSE="GPL"
HOMEPAGE="http://www.scilab.org/"
SRC_URI="http://www.scilab.org/download/${PV}/${PN}-src.tar.gz

SLOT="0/${PV}"
IUSE=""
	
KEYWORDS="~amd64-linux ~x86-linux"


PATCHES=(
)

pkg_pretend() {
}

src_prepare() {
	autotools-utils_src_prepare
}

src_configure() {
	autotools-utils_src_configure
}

src_compile() {
	emake
}

src_install() {
	autotools-utils_src_install
}
