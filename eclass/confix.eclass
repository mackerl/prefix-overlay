# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Michael Haubenwallner <michael.haubenwallner@salomon.at>
# Purpose: Confix provides a common API to bootstrap and build packages - use it.
#
# Confix is a package-maintainer tool on top of autotools, generating input-files
# for automake/autoconf, which have been handcrafted before confix.
#
# Confix is from http://confix.sourceforge.net
#

ECLASS="confix"
INHERITED="$INHERITED $ECLASS"

inherit libtool

DEPEND=">=dev-util/confix-2"

confix_bootstrap() {
	if [[ -r ./Confix2.pkg ]]; then
		pushd . >/dev/null || die
	else
		pushd "${S}" >/dev/null || die
	fi
	local outfile="${T}"/confix-maintainer-clean-temp.out
	local stat=
	if [[ -x ./configure ]]; then
		ebegin "making maintainer-clean"
		econf >> "${outfile}" 2>&1
		emake maintainer-clean >> "${outfile}" 2>&1
		stat=$?

		if [[ ${stat} != 0 ]]; then
			eend ${stat}
			cat "${outfile}"
			rm "${outfile}"
			die "make maintainer-clean before confix2 bootstrap failed"
		fi

		rm "${outfile}"
		eend 0
	fi

	CFX_LIBTOOL_FLAG="--use-libtool"

	[[ -n "${CFX_NO_LIBTOOL}" ]] && CFX_LIBTOOL_FLAG=""

	rm -f aclocal.m4 # prevent automake-wrapper to use old versions of automake.
	ebegin "confix2.py --bootstrap --prefix=${EPREFIX}/usr ${CFX_LIBTOOL_FLAG}"
	confix2.py --bootstrap --prefix="${EPREFIX}"/usr ${CFX_LIBTOOL_FLAG} > "${outfile}" 2>&1
	stat=$?

	if [[ ${stat} != 0 ]]; then
		eend ${stat}
		cat "${outfile}"
		rm "${outfile}"
		die "confix2 bootstrap failed"
	fi

	rm "${outfile}"
	eend 0

	elibtoolize

	popd >/dev/null
}

confix_src_unpack() {
	unpack ${A} || die
	if has ${EAPI:-0} 0 1; then
		confix_src_prepare
	fi
}

confix_src_prepare() {
	confix_bootstrap
}

confix_src_configure() {
	econf "$@"
}

confix_src_compile() {
	if has ${EAPI:-0} 0 1; then
		confix_src_configure "$@"
	fi
	emake || die "make failed"
}

confix_src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
}

confix_version() {
	confix2.py --version | awk '{ print $2 };'
}

if (( ${EAPI:-0} >= 2 )); then
	EXPORT_FUNCTIONS src_prepare src_configure
fi
EXPORT_FUNCTIONS src_unpack src_compile src_install
