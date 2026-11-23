#--------------------------------------------------
# System
#--------------------------------------------------

# Local operating system (Windows_NT, Darwin, Linux)
ifeq ($(OS),Windows_NT)
	_SYSTEM=$(OS)
else
	_SYSTEM=$(shell uname -s)
endif
