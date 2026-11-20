#--------------------------------------------------
# Symfony
#--------------------------------------------------

# get correct console executable
_CONSOLE=$(shell if [ -f ./app/console ]; then echo './app/console'; elif [ -f ./bin/console ]; then echo './bin/console'; fi)
# get correct public folder
_PUBLIC=$(shell if [ -d ./web ]; then echo './web'; elif [ -d ./public ]; then echo './public'; else echo './'; fi)
# get current php version
_PHP_VERSION=$(shell php -v | sed -n 's/^PHP \([0-9]*\.[0-9]*\).*/\1/p')
# symfony version
_SYMFONY_VERSION=$(shell if [ -f ./vendor/autoload.php ]; then ${_CONSOLE} --version; else echo 'Symfony not installed'; fi)
