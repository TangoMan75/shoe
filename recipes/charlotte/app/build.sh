#!/bin/sh

## Build app to "dist" folder
##
## {
##   "namespace": "app",
##   "requires": [
##     "cp",
##     "git",
##     "mkdir",
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
build() {
    _echo_info 'rm -rf ./dist\n'
    rm -rf ./dist

    _echo_info 'mkdir ./dist\n'
    mkdir ./dist

    _echo_info 'cp -r ./src/css ./dist/css\n'
    cp -r ./src/css ./dist/css

    _echo_info 'cp -r ./src/favicon ./dist/favicon\n'
    cp -r ./src/favicon ./dist/favicon

    _echo_info 'cp -r ./src/images ./dist/images\n'
    cp -r ./src/images ./dist/images

    _echo_info 'cp -r ./src/js ./dist/js\n'
    cp -r ./src/js ./dist/js

    _echo_info 'cp ./src/charlotte_wailly_cv.pdf ./dist/charlotte_wailly_cv.pdf\n'
    cp ./src/charlotte_wailly_cv.pdf ./dist/charlotte_wailly_cv.pdf

    _echo_info 'cp ./src/index.html ./dist/index.html\n'
    cp ./src/index.html ./dist/index.html
}
