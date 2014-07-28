local debugpackageslist="${EPREFIX}"/etc/debugpackages
local debugpackages=()
if [[ -r ${debugpackageslist} ]]
then
	debugpackages=( $(sed -e 's,#.*,,' < "${debugpackageslist}") )
fi

if [[ " ${debugpackages[*]} " == *" ${CATEGORY}/${PN} "* ]]
then
	if [[ ${EBUILD_PHASE} == 'setup' ]]
	then
		CFLAGS+=' -O0 -g'
		CXXFLAGS+=' -O0 -g'
	elif [[ ${EBUILD_PHASE} == 'install' ]]
	then
		FEATURES+=" nostrip"
	elif [[ ${EBUILD_PHASE} == 'postinst' ]]
	then
		elog "${CATEGORY}/${P} is built for debugging due to ${debugpackageslist}"
	elif [[ ${EBUILD_PHASE} == 'clean' && -d ${D}/. ]]
	then
		# in phase 'clean' before 'unpack', ${D} does not exist
		# in phase 'clean' after merge, ${D} does exist
		FEATURES+=" keepwork"
		# setting PORTAGE_WORKDIR_MODE=755 does not help,
		# as portage evaluates this within python code.
		[[ -d ${WORKDIR} ]] && chmod go+rx "${WORKDIR}"
	fi
else
	if [[ ${EBUILD_PHASE} == 'setup' ]]
	then
		: ${CFLAGS:=-O2}
		: ${CXXFLAGS:=-O2}
	fi
fi
post_src_unpack() {
    if type epatch_user &> /dev/null ; then
        if [[ -d ${S} ]]; then
            pushd "${S}" 2>/dev/null
            epatch_user
            popd 2>/dev/null
        else
            epatch_user
        fi
    fi
}
