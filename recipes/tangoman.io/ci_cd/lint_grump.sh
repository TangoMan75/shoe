#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run grumphp",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
lint_grump() {
    # exec 'vendor/phpro/grumphp/bin/grumphp' 'git:pre-commit' '--skip-success-output'
    _echo_info "php -d memory-limit=-1 ./vendor/phpro/grumphp/bin/grumphp git:pre-commit --skip-success-output\n"
    php -d memory-limit=-1 ./vendor/phpro/grumphp/bin/grumphp git:pre-commit --skip-success-output
}

