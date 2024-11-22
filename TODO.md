TODO
====

14:46 22/11/2024

## Make / Shell Comparator

|           Make          |          shell          |
|-------------------------|-------------------------|
| + autocompletion native | + autocompletion shoe   |
| - compatibilité         | + compatibilité         |
| - passer des paramètres | + passer des paramètres |
| - shellcheck            | + shellcheck            |
| - syntaxe               | + syntaxe               |
| - validation            | + validation shoe       |

## Makefile generator

## Script generator

## Update simple annotation/documentation system

eg:

```
#/**
# * @description Print "Hello" in the terminal.
# * @usage       foobar
# * @requires    application
# * @env         ENVIRONMENT_VARIABLE
# * @arg         argname   <argument description>
# * @param       name      <parameter description>
# * @option      -o        <option description>
# * @option      -o|option <option description>
# * @flag
# */
```

## advanced annotation system

eg:

```
foobar hello --who TangoMan --version
```

|    name    |           description           |
|------------|---------------------------------|
| Command    | can own arguments               |
| Command    | can own flags                   |
| Command    | can own global alias            |
| Command    | can own parameters              |
| Command    | must auto generate help         |
|------------|---------------------------------|
| Arguments  | always optional                 |
| Arguments  | can own flags                   |
| Arguments  | can own parameters              |
|------------|---------------------------------|
| Parameters | can own a scope                 |
| Parameters | can own shortname               |
| Parameters | can own validation              |
| Parameters | must own value or default value |
|------------|---------------------------------|
| Flags      | can own a scope                 |
| Flags      | must always default to `false`  |
| Flags      | no validation                   |

### Global config

```json
{
  "name": "foobar",
  "alias": "foo",
  "summary": "A basic example.",
  "description": "\"foobar\" command demonstrates a basic shoe advanced annotation example.",
  "args": [
    {
      "name": "hello",
      "short": "H",
      "summary": "Print \"Hello, World!\" in the terminal.",
      "description": "Argument example that allows to print a greeting message on the screen.",
      "params": [
        {
          "name": "who",
          "short": "w",
          "summary": "Recipient name",
          "description": "Parameter example that allows to print a greeting message to an arbitrary recipient on the screen.",
          "validation": "/[A-Za-z]/",
          "default": "World"
        }
      ],
      "flags": []
    },
    {
      "name": "help",
      "short": "h",
      "summary": "Print help.",
      "description": "Prints this help in the terminal.",
      "priority": 1,
      "note": "Overrides other arguments.",
      "params": [],
      "flags": []
    }
  ],
  "params": [],
  "flags": [
    {
      "name": "version",
      "short": "v",
      "summary": "Print version.",
      "description": "Prints version in semver format.",
      "priority": 2,
      "note": "Overrides other arguments."
    }
  ]
}
```

### Command

```json
{
  "alias": "foo",
  "description": "A basic example.",
  "note": "\"foobar\" command demonstrates a basic shoe advanced annotation example.",
  "args": [
      "hello",
      "help"
  ],
  "params": [],
  "flags": [
      "version"
  ]
}
```

### Argument

hello
```json
{
  "short": "H",
  "params": [
    "who"
  ]
}
```

help
```json
{
  "short": "h"
}
```

### Parameter

```json
{
    "short": "w",
    "summary": "Recipient name",
    "description": "Parameter example that allows to print a greeting message to an arbitrary recipient on the screen.",
    "validation": "/[A-Za-z]/",
    "default": "World",
    "scope": [
      "hello"
    ]
}
```

### Flag

```json
{
  "short": "v",
    "scope": [
      "hello"
    ]
}
```

## Shortnames

| -? | --help                            |
| -a | --all                             |
| -A | --author                          |
| -b | --branch                          |
| -B | --pick-branch                     |
| -c | --commit, --clean, --container    |
| -C | --pick-commit                     |
| -d | --delete, --docker, --dry-run     |
| -D | --force-delete, --delete-remote   |
| -e | --extension                       |
| -E |                                   |
| -f | --file-path, --force, --fetch     |
| -F | --filter                          |
| -g | --graph                           |
| -G | --no-graph                        |
| -H | --https                           |
| -h | --help                            |
| -i | --input, --install, --ide, --ip   |
| -I | --interactive                     |
| -j |                                   |
| -J |                                   |
| -K |                                   |
| -k | --kill                            |
| -L |                                   |
| -l | --list                            |
| -m |                                   |
| -M |                                   |
| -N |                                   |
| -n | --number --no                     |
| -o | --output                          |
| -O |                                   |
| -P |                                   |
| -p | --print, --public, --port, --ping |
| -Q |                                   |
| -q | --quit                            |
| -R |                                   |
| -r | --remove, --rename, --recursive   |
| -s | --server                          |
| -S |                                   |
| -t | --type                            |
| -T |                                   |
| -u | --user                            |
| -U |                                   |
| -V |                                   |
| -v | --verbose                         |
| -w |                                   |
| -W |                                   |
| -x |                                   |
| -X |                                   |
| -Y |                                   |
| -y | --assume-yes                      |
| -z |                                   |
| -Z |                                   |
