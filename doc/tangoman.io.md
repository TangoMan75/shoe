TangoMan.io
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io> "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-xl 1.0.0
- link:    https://github.com/TangoMan75/tangoman.io https://github.com/TangoMan75/shoe

## 📑 Description

This is the main entrypoint for tangoman.io project    TangoMan shoe  Run "make" to print help If you want to add a help message for your rule,  just add : "## My help for this rule", on the previous line use : "### " to group rules by categories You can give "make" arguments with this syntax: PARAMETER=VALUE   

## 🔥 Usage

`sh tangoman.io.sh [command] (--env dev) (--port 8000) (--table '') (--container '') (--owner '') (--file '') (--migrate) (--import) (--force)`

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: _tangoman_

## 🚩 Flags

1. **`--migrate`**
  - Execute migrations instead of creating schema

2. **`--import`**
  - Import csv data

3. **`--force`**
  - Force

## ⚙️ Options

1. **`--env`**
  - Description: Environment 
  - Constraint: `/^(dev|prod|test)$/`
  - Default: _dev_

2. **`--port`**
  - Description: Default port 
  - Constraint: `/^[0-9]+$/`
  - Default: _8000_

3. **`--table`**
  - Description: Table name 
  - Constraint: `/^[a-z0-9_]+$/`
  - Default: _''_

4. **`--container`**
  - Description: Container name 
  - Constraint: `/^[a-zA-Z0-9_-]+$/`
  - Default: _''_

5. **`--owner`**
  - Description: Files owner 
  - Constraint: `/^[a-z0-9_-]+$/`
  - Default: _''_

6. **`--file`**
  - Description: File to test 
  - Constraint: `/^~?[a-zA-Z0-9.\/_-]+$/`
  - Default: _''_

## 🤖 Commands

1. **`install`**
  - Install app, import data and clear cache

2. **`uninstall`**
  - Uninstall

3. **`requirements`**
  - Check requirements

4. **`rm_env`**
  - Remove ".env.local" and ".env.dev.local" files

5. **`set_env`**
  - Create ".env.local" file

6. **`update`**
  - Update app : git pull, reset database and import (docker)

7. **`clear_exports`**
  - Clear export folder

8. **`export_csv`**
  - Export data in csv

9. **`export_json`**
  - Export data in json

10. **`import`**
  - Import data

11. **`scrape_syntec`**
  - Scrape data from "Syntec" website

12. **`scrape_wttj`**
  - Scrape data from "Welcome to the Jungle" website

13. **`check_drivers`**
  - Check drivers installation

14. **`coverage`**
  - Output test coverage (phpunit)

15. **`lint`**
  - Run linter (sniff)

16. **`lint_fix`**
  - Run linter (php-cs-fixer fix)

17. **`lint_grump`**
  - Run grumphp

18. **`lint_phpstan`**
  - Run code analysis with PHPStan

19. **`security`**
  - Check security issues in project dependencies (symfony-cli)

20. **`tests`**
  - Run tests

21. **`tests_behat`**
  - Run behat tests

22. **`tests_functional`**
  - Run functional tests

23. **`tests_integration`**
  - Run integration tests

24. **`tests_unit`**
  - Run unit tests

25. **`create_db`**
  - Create database

26. **`database_import`**
  - Import SQL file(s) directly to Database

27. **`drop`**
  - Drop database

28. **`generate_schema`**
  - Generate schema from yaml (api-platform)

29. **`migrate`**
  - Execute migration scripts

30. **`migration_diff`**
  - Generate migration script

31. **`mysqldump`**
  - Dump MySQL database (docker)

32. **`pg_dump`**
  - Dump Postgres database (docker)

33. **`psql`**
  - Enter Postgres terminal

34. **`reset_db`**
  - Reset database (without imports)

35. **`schema`**
  - Create schema

36. **`truncate`**
  - Truncate table

37. **`alice`**
  - Load Alice fixtures

38. **`fixtures`**
  - Load fixtures (doctrine)

39. **`cron`**
  - Run shapecode cron

40. **`cron_scan`**
  - Scan shapecode cron

41. **`generate_jwt`**
  - Generate JWT keys (jwt bundle)

42. **`own`**
  - Own project files

43. **`serve`**
  - Serve locally with PHP or Symfony

44. **`version`**
  - Print version infos

45. **`certificates`**
  - Install local SSL certificates

46. **`certificates_remove`**
  - Remove local SSL certificates

47. **`hosts`**
  - Set /etc/hosts (local only)

48. **`remove_hosts`**
  - Remove /etc/hosts (local only)

49. **`build`**
  - Build containers

50. **`container_ip`**
  - Get running container ip

51. **`container_name`**
  - Get container full name

52. **`docker_logs`**
  - Print Docker log

53. **`fix_permissions`**
  - Fix permission issue (777 hack)

54. **`generate_app_secret`**
  - Generate APP_SECRET

55. **`images_remove`**
  - Remove images

56. **`network`**
  - Create "traefik" network

57. **`network_remove`**
  - Remove "traefik" network

58. **`open`**
  - Open container in default browser

59. **`permissions`**
  - Set correct permissions

60. **`remove_symlink`**
  - Remove symlink

61. **`shell`**
  - Shell into "php" container

62. **`start`**
  - Build and start container stack

63. **`status`**
  - Print app status

64. **`stop`**
  - Stop container stack

65. **`symlink`**
  - Create symlink to match container project directory structure

66. **`up`**
  - Create network, build container, start docker, composer install, create database, import data

67. **`assetic`**
  - Dump app assets

68. **`assets_install`**
  - Install bundle assets

69. **`ckeditor`**
  - Install Ck Editor

70. **`encore`**
  - Run webpack encore

71. **`encore_watch`**
  - Watch with webpack encore

72. **`sass_build`**
  - Compile scss

73. **`sass_watch`**
  - Watch scss

74. **`composer_install`**
  - Install project dependencies with composer

75. **`cache`**
  - Clear cache

76. **`self_install`**
  - Install script and enable completion

77. **`self_uninstall`**
  - Uninstall script from system

78. **`self_update`**
  - Update script from @update-link

79. **`generate_doc`**
  - Generate Markdown documentation for current shoe script

80. **`generate_makefile`**
  - Generate Makefile documentation for current shoe script

81. **`help`**
  - Print this help (default)

