#--------------------------------------------------
# Help
#--------------------------------------------------

## Print this help
help:
	$(call _alert_primary, '{{ summary }}')

	@printf "${_WARNING}Infos${_EOL}"
	@printf "${_SUCCESS}  author:  ${_PRIMARY} %s${_EOL}" '{{ author }}'
	@printf "${_SUCCESS}  version: ${_PRIMARY} %s${_EOL}" '{{ version }}'
	@printf "${_SUCCESS}  license: ${_PRIMARY} %s${_EOL}" '{{ license }}'
	@printf "${_SUCCESS}  link:    ${_PRIMARY} %s${_EOL}" '{{ link }}'
	@printf "${_EOL}"

	@printf "${_WARNING}Description${_EOL}"
	@printf "${_PRIMARY}  %s${_EOL}\n" '{{ description }}'

	@printf "${_WARNING}Usage${_EOL}"
	@printf "${_PRIMARY}  make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${_EOL}\n"

	@printf "${_WARNING}Options${_EOL}"
	$(eval CONFIG:=$(shell awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"$${_SUCCESS} %-16s$${_DEFAULT}$${_PRIMARY} $${_%s}$${_EOL}\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq))
	@printf " $(CONFIG)\n"

	@printf "${_WARNING}Commands${_EOL}"
	@awk '/^### /{printf"\n${_WARNING}%s${_EOL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf "  ${_SUCCESS}%-16s${_DEFAULT} ${_PRIMARY}%s${_EOL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}
