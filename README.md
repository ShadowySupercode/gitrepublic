# GitRepublic
## Your open-source home for your open-source projects.

### Who we are
- Product Owner and Dev: [@buttercat1791](https://github.com/buttercat1791)
- Business Analyst and Validator: [@SilberWitch](https://github.com/silberwitch)
- DevOps and Dev: [@finrodfelagund97](https://github.com/finrodfelagund97)
- Dev: [@captain-stacks](https://github.com/captain-stacks)

### Where we are
https://nostrudel.ninja/#/u/npub1s3ht77dq4zqnya8vjun5jp3p44pr794ru36d0ltxu65chljw8xjqd975wz

### What we do
We have put together a team to provide a replacement for GitHub that:
- is decentralized and distributed, through the use of git functionality
- is free and open-source (FOSS)
- can be used without offering any personal identification
- utilizes open protocols (Nostr and Lightning Network)
- can intuitively manage multiple remote repos within one project
- contains all of the functionality that you need to manage your repos and your projects
- is censorship-resistent

# Workspace Installation Instructions
## Initializing the development environment
For this project, a developer only needs to start with a GNU GCC compiler and a Python interpreter and the CMake build system installed properly on your machine.

If you are on macOS or Linux, we have a provided a series of step to ensure you have a working installation
of these tools listed above.

First of all, make sure the following tools are installed on your system: `git`, `wget` and `build-essential` if you're on Linux, or `Xcode Command Line tools` if you're on macOS.

To install this workspace, please refer to the following steps:

1. Open a terminal window.
2. Clone this current repository:
```bash
git clone <repo-url>
```

3. Go into the repository folder:
```bash
cd GitRepulbic
```

4. Setup execution permissions properly:
```bash
chmod +x install.sh
```

5. Execute the `install.sh` script that installs `gcc-13.2.0`, `cmake-3.29.1` and `python3.12.1`
to be used as the development environment for this workspace. This might take a while, depending on the speed of your processor. If your CPU has many cores, don't hesitate to use the `-j` option to accelerate the build of the development environment. **CHECK** how many cores your CPU has before putting a high value for the `-j` option. For example:
```bash
./install.sh -j 4
```

Now that this is done, it won't be needed for a second time.

To use the installed environment, the `setenv` file must be sourced:
```bash
source setenv
```
To unset the environment and return all environment variables to their default value:
```bash
unsetenv
```

To check if the envrionment has been properly set up, execute this following command:
```bash
printenv
```
In the printed output, check that the current envrionment is present in the variables `$PATH` and `$LD_LIBRARY_PATH`, `$PS1`, `$CC` and `$CXX`.

Also, execute the following commands to verify the versions of the tools:
```bash
which gcc; which python; gcc -v; python -V
```
The ouput should point to the version installed in this workspace in the `env` folder.

NOTE: There is no absolute need to run the `install.sh` script on your system, although it is recommended. What is necessary though is to have a recent working Python and GNU-GCC installations.

## Seeding the workspace with the required repositories

Once the development environment and dependencies have been properly installed, the required repos must be cloned to populate the workspace with its components. These repos are defined in the manifest file and the default file is the master manifest found in `.manifests/master.yaml` that tracks the master branches of all the required repos. Anyone can define their own manifest detailing their own versions of each required repo.

To manually install `vcstool`, simply install it using `pip`:
```bash
pip3 install vcstool
```

What's recommended though is to create a virtual environment inside `GitRepublic`.

```bash
./pythonenv.sh # creates a virtual environment only if no environment exists yet.
```

Remember to activate the virtual environment by sourcing the file `.venv/bin/activate`
```bash
source .venv/bin/activate
```

To deactivate the virtual environment, in a shell where it is activated, execute this command:
```bash
deactivate
```

Once `vcstool` has been installed, seed the workspace by executing this command in the terminal:

```bash
vcs import < .manifests/master.yaml | vcstool import < .manifest/master.yaml # or use any other manifest
```

## Build GitRepublic
To build `GitRepublic`, we shall be using `vcpkg` and `cmake` for building and managing library dependencies, packaging, etc.

### Bootstrap vcpkg

`vcpkg` will be cloned in the workspace of `GitRepublic` after seeding the workspace using `vcstool`.
For more details: https://learn.microsoft.com/en-us/vcpkg/get_started/get-started

To bootstrap `vcpkg` follow these steps:

```bash
cd vcpkg
chmod +x bootstrap-vcpkg.sh
./bootstrap-vcpkg.sh
```

Add the `vcpkg` directory to `$PATH`:

```bash
export VCPKG_ROOT="GitRepublic/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
```

So far, there isn't a build script at the level of `GitRepublic` that builds the whole project, yet.
For now, each submodule must be build individually according to its own build instructions.

### Manually build individual submodules using `cmake` with `vcpkg`
Go into the target submodule.

```bash
cd <path-to-submodule>
```
If it has never been built before, otherwise skip this step:

```bash
vcpkg new --application
```

To manually add all the dependencies:
```bash
vcpkg add port <dependency1> <dependency2> <dependency3> ...
```

Or create a `vcpkg.json` manifest file inside the submodule:

```json
{
    "dependencies": [
        "dependency1",
        "dependency2",
        "dependency3",
    ]
}
```

In order for `cmake` to recognize the libraries provided by `vcpkg`,
the `vcpkg.cmake` toolchain file must be provided to `cmake`. To do that,
the `$CMAKE_TOOLCHAIN_FILE` cmake cache variable must be set to the path of the `vcpkg.cmake` file.
To do that, call `cmake` in the terminal like this
```bash
cmake -D CMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" [other-options]
```
To automate that, a smarter way is to use a `CMakePresets.json` inside the submodule:

```json
{
  "version": 2,
  "configurePresets": [
    {
      "name": "default",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
        // other CMAKE Cache variables
      }
    },
    // other presets here if need be
  ]
}
```

To configure the build, execute this command:
```bash
cmake --preset=default
```
To build the submodule, execute this command:
```bash
cmake --build build
```

The binary output will be placed in the following path: `GitRepublic/out/[bin|lib|lib/static]`
respectively for binary executables, shared libraries and archives.