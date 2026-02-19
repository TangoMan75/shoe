#!/bin/sh

## Generate JWT keys (jwt bundle)
##
## {
##   "namespace": "development",
##   "requires": [
##     "cut",
##     "grep",
##     "mkdir",
##     "openssl"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
generate_jwt() {
    _echo_info 'rm -rf ./config/jwt\n'
    rm -rf ./config/jwt

    _echo_info 'mkdir -p ./config/jwt\n'
    mkdir -p ./config/jwt

    _echo_info 'grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl genpkey -out ./config/jwt/private.pem -pass stdin -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096\n'
    grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl genpkey -out ./config/jwt/private.pem -pass stdin -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096

    _echo_info 'grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl pkey -in ./config/jwt/private.pem -passin stdin -out ./config/jwt/public.pem -pubout\n'
    grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl pkey -in ./config/jwt/private.pem -passin stdin -out ./config/jwt/public.pem -pubout
}

