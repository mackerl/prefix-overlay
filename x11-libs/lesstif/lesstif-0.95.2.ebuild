# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/x11-libs/lesstif/lesstif-0.95.0-r1.ebuild,v 1.3 2009/07/03 15:38:13 darkside dead $

inherit eutils multilib libtool

DESCRIPTION="An OSF/Motif(R) clone"
HOMEPAGE="http://www.lesstif.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ppc-aix ~x86-fbsd hppa-hpux ia64-hpux x86-linux sparc-solaris x86-solaris"
IUSE="static"

RDEPEND="!x11-libs/motif-config
	!x11-libs/openmotif
	!<=x11-libs/lesstif-0.95.0
	x11-libs/libXp
	x11-libs/libXt
	x11-libs/libXft"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#epatch "${FILESDIR}/CAN-2005-0605.patch"
	#epatch "${FILESDIR}/${P}-vendorsp-cxx.patch"

	epatch "${FILESDIR}"/${P}-no-m4.patch
	epatch "${FILESDIR}"/${P}-xmlibexport.patch
	elibtoolize
}

src_compile() {
	econf \
		$(use_enable static) \
		--enable-production \
		--enable-verbose=no \
		--with-x \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir) \
	|| die "econf failed"

	emake CFLAGS="${CFLAGS}" \
		mwmddir="${EPREFIX}"/etc/X11/mwm \
		|| die "emake failed"
}

src_install() {
	[[ -z ${ED} ]] && local ED=${D}

	emake DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		appdir="${EPREFIX}"/usr/share/X11/app-defaults \
		mwmddir="${EPREFIX}"/etc/X11/mwm \
		install || die "emake install failed"

	dodoc AUTHORS BUG-REPORTING ChangeLog CREDITS FAQ NEWS README \
		ReleaseNotes.txt
	newdoc "${ED}"/etc/X11/mwm/README README.mwm

	# cleanup
	rm -f "${ED}"/etc/X11/mwm/README
	rm -f "${ED}"/usr/bin/motif-config
	rm -f "${ED}"/usr/bin/mxmkmf
	rm -fR "${ED}"/usr/LessTif
	rm -fR "${ED}"/usr/$(get_libdir)/LessTif
}
