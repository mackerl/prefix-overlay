# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Michael Haubenwallner <michael.haubenwallner@salomon.at>
# Purpose: Keep ebuilds for confix-repos collected in wx-toolsbox small.
#

ECLASS="wx-toolsbox"
INHERITED="$INHERITED $ECLASS"

inherit versionator confix

DESCRIPTION="confix-repo for ${PN%-repo}"
HOMEPAGE="http://salxis.salomon.at/download/pf/3110/download/wamas-environment/wx-toolsbox/"

SRC_URI="http://salxis.salomon.at/download/pf/3110/download/wamas-environment/wx-toolsbox/$(
		get_version_component_range 1-2 ${PV}
	)/${P}.tar.bz2"

LICENSE="salomon"
SLOT=0
