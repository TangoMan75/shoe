TangoMan Traefik
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-md
- link:    https://github.com/TangoMan75/traefik

## 📑 Description

Awesome **TangoMan Traefik** is a fast and handy tool to manage Traefik with Docker.   

## 🔥 Usage

`sh traefik.sh [command] (--env dev) (--network '') (--user '') (--password '') (--email '') `

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: _traefik_

## ⚙️ Options

1. **`--env`**
  - Description: Environment 
  - Constraint: `/^(dev|prod)$/`
  - Default: _dev_

2. **`--network`**
  - Description: Network 
  - Constraint: `/^[a-z0-9_-]+$/`
  - Default: _''_

3. **`--user`**
  - Description: User 
  - Constraint: `/^[a-z0-9_-]+$/`
  - Default: _''_

4. **`--password`**
  - Description: Password 
  - Constraint: `/^.+$/`
  - Default: _''_

5. **`--email`**
  - Description: email 
  - Constraint: `/^.+@.+\..+$/`
  - Default: _''_

## 🤖 Commands

1. **`up`**
  - Build and start traefik

2. **`set_env`**
  - Set dev or prod environment

3. **`requirements`**
  - Check requirements

4. **`uninstall`**
  - Uninstall Traefik

5. **`open`**
  - Open traefik and whoami dashboard in default browser

6. **`clear`**
  - Clear logs

7. **`backup`**
  - Backup traefik configuration

8. **`restore`**
  - Restore traefik configuration

9. **`password`**
  - Set traefik dashboard password

10. **`letsencrypt`**
  - Config letsencrypt

11. **`acme`**
  - Create empty Let's Encrypt acme.json file

12. **`email`**
  - Set Let's Encrypt email

13. **`certs`**
  - Install local SSL certificates

14. **`remove_certs`**
  - Remove local SSL certificates or acme.json

15. **`network`**
  - Create network

16. **`remove_network`**
  - Remove network

17. **`build`**
  - Build docker stack

18. **`start`**
  - Start docker stack

19. **`stop`**
  - Stop docker stack

20. **`lint`**
  - Sniff errors with linters

21. **`lint_yaml`**
  - Sniff errors with yamllint

22. **`lint_shell`**
  - Sniff errors with shellcheck

23. **`self_install`**
  - Install script and enable completion

24. **`self_uninstall`**
  - Uninstall script from system

25. **`generate_doc`**
  - Generate Markdown documentation for current shoe script

26. **`help`**
  - Print this help (default)

