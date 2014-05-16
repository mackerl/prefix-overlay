# Copyright 1999-2014 Salomon Automation GmbH
# Distributed # $Header: $ 
EAPI=2

inherit eutils confix

if [[ ${PV} == 9999 ]]; then
	ECVS_LOCALNAME=${PN}-HEAD
	ECVS_SERVER=salxsource01.salomon.at:/cvsroot
	ECVS_MODULE=saloon/wamas_x/utilities/logging/cpp/logtool
	ECVS_BRANCH=HEAD
	ECVS_AUTH=pserver
	ECVS_USER=${SALXSOURCE01_CVS_USER:-${PORTAGE_ROOT_USER}}
	ECVS_PASS=${SALXSOURCE01_CVS_PASS:-}
	inherit cvs

	SRC_URI=""
	S="${ECVS_TOP_DIR}/${ECVS_LOCALNAME}"
else
	SRC_URI="http://sapc154.salomon.at/pub/source/closed/logtool/${P}-raw.tar.bz2"
fi

DESCRIPTION="wamas platform logtool"
HOMEPAGE="http://salxis.salomon.at/download/pf/3110/download/wamas-environment/logtool"

LICENSE="salomon"
SLOT="0"
KEYWORDS="~ppc-aix ~hppa-hpux ~ia64-hpux ~x86-linux ~sparc-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="
	dev-libs/boost
	>=wamas-platform/logging-1.1.2
	wamas-platform/wamas-runtime
"
DEPEND="${RDEPEND}
	dev-confix/boost-repo
	sys-devel/bison
"

pkg_setup() {
	has_version '>=dev-libs/boost-1.34' ||
	built_with_use dev-libs/boost threads ||
	die "dev-libs/boost must be built with 'threads' in USE."
	EXTRA_ECONF="--with-boost --with-boost-thread=boost_thread"
	if [[ ${PV} == 9999 ]]; then
		addwrite "${S}"
	fi
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		sed -i -e "/PACKAGE_VERSION/s,cvsversion,'2.2.2'," Confix2.pkg || die
	fi
	epatch "${FILESDIR}"/logtool-2.3.1-cerr.patch
	epatch "${FILESDIR}"/logtool-2.3.1-cycleTime.patch
	epatch "${FILESDIR}"/bug37466.patch
	epatch "${FILESDIR}"/logtool-2.3.1-bison.patch
	confix_bootstrap
}
