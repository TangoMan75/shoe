TangoMan.io
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.11.3-xl
- link:    https://github.com/TangoMan75/tangoman.io

## 📑 Description

This is the main entrypoint for tangoman.io project   

## 🔥 Usage

`sh tangoman.io.sh [command] (--env dev) (--port 8000) (--table '') (--container '') (--owner '') (--file '') (--migrate) (--import) (--force)`

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: tangoman

## 🚩 Flags

1. **--migrate**
  - Execute migrations instead of creating schema

2. **--import**
  - Import csv data

3. **--force**
  - Force

## ⚙️ Options

1. **--env**
  - Description: Environment 
  - Constraint: `/^(dev|prod|test)$/`
  - Default: dev

2. **--port**
  - Description: Default port 
  - Constraint: `/^[0-9]+$/`
  - Default: 8000

3. **--table**
  - Description: Table name 
  - Constraint: `/^[a-z0-9_]+$/`
  - Default: ''

4. **--container**
  - Description: Container name 
  - Constraint: `/^[a-zA-Z0-9_-]+$/`
  - Default: ''

5. **--owner**
  - Description: Files owner 
  - Constraint: `/^[a-z0-9_-]+$/`
  - Default: ''

6. **--file**
  - Description: File to test 
  - Constraint: `/^~?[a-zA-Z0-9.\/_-]+$/`
  - Default: ''

## 🤖 Commands

1. **cache**
  - Clear cache

2. **clear_exports**
  - Clear export folder

3. **create_db**
  - Create database

4. **export_csv**
  - Export data in csv

5. **export_json**
  - Export data in json

6. **import**
  - Import data

7. **reset_db**
  - Reset database (without imports)

8. **scrape_syntec**
  - Scrape data from "Syntec" website

9. **scrape_wttj**
  - Scrape data from "Welcome to the Jungle" website

10. **status**
  - Print app status

11. **install**
  - Install app, import data and clear cache

12. **rm_env**
  - Remove ".env.local" and ".env.dev.local" files

### ⚡ App Install

1. **set_env**
  - Create ".env.local" file

2. **uninstall**
  - Uninstall

3. **check_drivers**
  - Check drivers installation

4. **coverage**
  - Output test coverage (phpunit)

5. **lint**
  - Run linter (sniff)

6. **lint_fix**
  - Run linter (php-cs-fixer fix)

7. **lint_grump**
  - Run grumphp

8. **lint_phpstan**
  - Run code analysis with PHPStan

9. **security**
  - Check security issues in project dependencies (symfony-cli)

10. **tests**
  - Run tests

11. **tests_behat**
  - Run behat tests

12. **tests_functional**
  - Run functional tests

13. **tests_integration**
  - Run integration tests

14. **tests_unit**
  - Run unit tests

15. **update**
  - Update app : git pull, reset database and import (docker)

16. **alice**
  - Load Alice fixtures

17. **database_import**
  - Import SQL file(s) directly to Database

18. **drop**
  - Drop database

19. **fixtures**
  - Load fixtures (doctrine)

20. **generate_schema**
  - Generate schema from yaml (api-platform)

21. **migrate**
  - Execute migration scripts

22. **migration_diff**
  - Generate migration script

23. **mysqldump**
  - Dump MySQL database (docker)

24. **pg_dump**
  - Dump Postgres database (docker)

25. **psql**
  - Enter Postgres terminal

26. **schema**
  - Create schema

27. **truncate**
  - Truncate table

28. **certificates**
  - Install local SSL certificates

29. **certificates_remove**
  - Remove local SSL certificates

30. **composer_install**
  - Install project dependencies with composer

31. **cron**
  - Run shapecode cron

32. **cron_scan**
  - Scan shapecode cron

33. **generate_jwt**
  - Generate JWT keys (jwt bundle)

34. **hosts**
  - Set /etc/hosts (local only)

35. **own**
  - Own project files

36. **remove_hosts**
  - Remove /etc/hosts (local only)

37. **serve**
  - Serve locally with PHP or Symfony

38. **version**
  - Print version infos

39. **build**
  - Build containers

40. **container_ip**
  - Get running container ip

41. **container_name**
  - Get container full name

42. **docker_logs**
  - Print Docker log

43. **fix_permissions**
  - Fix permission issue (777 hack)

44. **generate_app_secret**
  - Generate APP_SECRET

45. **images_remove**
  - Remove images

46. **network**
  - Create "traefik" network

47. **network_remove**
  - Remove "traefik" network

48. **open**
  - Open container in default browser

49. **permissions**
  - Set correct permissions

50. **remove_symlink**
  - Remove symlink

51. **shell**
  - Shell into "php" container

52. **start**
  - Build and start container stack

53. **stop**
  - Stop container stack

54. **symlink**
  - Create symlink to match container project directory structure

55. **up**
  - Create network, build container, start docker, composer install, create database, import data

56. **assetic**
  - Dump app assets

57. **assets_install**
  - Install bundle assets

58. **ckeditor**
  - Install Ck Editor

59. **encore**
  - Run webpack encore

60. **encore_watch**
  - Watch with webpack encore

61. **sass_build**
  - Compile scss

62. **sass_watch**
  - Watch scss

### ⚡ Self Install

1. **self_install**
  - Install script and enable completion

2. **self_uninstall**
  - Uninstall script from system

3. **self_update**
  - Update script from @update-link

### ⚡ Documentation

1. **generate_doc**
  - Generate Markdown documentation

### ⚡ Help

1. **help**
  - Print this help (default)

