
#--------------------------------------------------
# Echo Functions
#--------------------------------------------------

define _echo_primary
	@printf "${_PRIMARY}%b${_EOL}" $(1)
endef
define _echo_secondary
	@printf "${_SECONDARY}%b${_EOL}" $(1)
endef
define _echo_success
	@printf "${_SUCCESS}%b${_EOL}" $(1)
endef
define _echo_danger
	@printf "${_DANGER}%b${_EOL}" $(1)
endef
define _echo_warning
	@printf "${_WARNING}%b${_EOL}" $(1)
endef
define _echo_info
	@printf "${_INFO}%b${_EOL}" $(1)
endef
define _echo_muted
	@printf "${_MUTED}%b${_EOL}" $(1)
endef
define _echo_light
	@printf "${_LIGHT}%b${_EOL}" $(1)
endef
define _echo_dark
	@printf "${_DARK}%b${_EOL}" $(1)
endef
define _echo_error
	@printf "${_DANGER}error: %b${_EOL}" $(1)
endef

