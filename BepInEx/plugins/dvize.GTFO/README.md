# GTFO

Displays extract markers and Quests markers in raid visually so that players
can learn to navigate the maps.

## Source code

The source code for this plugin is published [here](https://gitlab.com/flir063-spt/gtfo)

## Building

To build this project you must use the dotnet command (or Visual Studio).

We provide a `.envrc.sample` file. Copy to `.envrc` and modify it
with the desired values. You will then need to install direnv and
make sure to allow direnv to load this config file:

  ```sh
  direnv allow
  ```

We provide a Taskfile to help build, package and upload to gitlab.
This task file used tools that will require the environment variables
you have previously set in your `.envrc` file.

Commands are:

  - task build : to build the dll
  - task build-debug : to build the dll in debug mode, for testing only
  - task package : to create the zipfile for release
  - task upload : to upload the zipfile to gitlab

## Note

We are in the process of migrating to mise and replace direnv and task by
a single mise definition... More on that later

## Special note for windows

If you want to make use of the package and upload tool on Windows you will
need to use git bash and install [direnv](https://gist.github.com/rmtuckerphx/4ace28c1605300462340ffa7b7001c6d)
