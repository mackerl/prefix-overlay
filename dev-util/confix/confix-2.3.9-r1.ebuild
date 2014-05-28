# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/confix/confix-2.1.0-r3.ebuild,v 1.2 2009/10/16 08:18:01 haubi Exp $
EAPI="4"

inherit distutils eutils


DESCRIPTION="Confix: A Build Tool on Top of GNU Automake"
HOMEPAGE="http://confix.sourceforge.net"
SRC_URI="mirror://sourceforge/confix/Confix-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="ppc-aix hppa-hpux ia64-hpux x86-interix x86-linux sparc-solaris x86-solaris"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}
	sys-devel/automake
	sys-devel/libtool
	sys-devel/autoconf-archive
	dev-util/confix-wrapper
"

S="${WORKDIR}/Confix-${PV}"
PYTHON_MODNAME="libconfix tests"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# find jni-include dirs on hpux.
	epatch "${FILESDIR}"/2.1.0/jni-hpux.patch
	# add .exe extension to TESTS
	epatch "${FILESDIR}"/2.3.0/exeext.patch
	# use external autoconf archive
	epatch "${FILESDIR}"/2.3.0/ext-ac-archive.patch
	# link local libraries first.
	epatch "${FILESDIR}"/2.3.0/local-libs-first.patch
	# don't use automake 1.9, but any newer too...
	epatch "${FILESDIR}"/2.3.0/new-automake.patch
}

pkg_preinst() {
	local RV=2.3.0

	if has_version "<dev-util/confix-${RV}"; then
		einfo "After merging ${P} you might have to remerge all packages built"
		einfo "with <dev-util/confix-${RV} in your EPREFIX to get all the"
		einfo "repo files useable with current ${PN}".
		ewarn
		ewarn "Use this command (copy&paste) to identify packages built with confix"
		ewarn "needing a remerge in your particular instance of Gentoo Prefix:"
		ewarn
		# use 'echo' to get this command from here:
		ewarn "( cd \$(portageq envvar EPREFIX)/var/db/pkg || exit 1;" \
			  "pattern=\$(cd ../../.. && echo \$(ls -d" \
			  "usr/share/confix*/repo | grep -v confix-${RV}) |" \
			  "sed -e 's, ,|,g'); if [[ -z \${pattern} ]]; then echo" \
			  "'No more packages were built with broken Confix.'; exit 0;" \
			  "fi; emerge --ask --oneshot \$(grep -lE \"(\${pattern})\"" \
			  "*/*/CONTENTS | sed -e 's,^,>=,;s,/CONTENTS,,')" \
			  ")"
		ewarn
	fi
}