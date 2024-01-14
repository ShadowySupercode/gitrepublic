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

## Workspace Installation Instructions
To install this workspace, please refer to the following steps:

1. Open a terminal window.
1. Clone this current repository:
```
git clone <repo-url>
```

2. Go into the repository folder:
```
cd GitRepulbic
```
3. Execute the `install.sh` script that installs `gcc-13.2.0`, `cmake-3.28.1` and `python3.12.1`
to be used as the development environment for this workspace. This might take a while, around an hour. If your CPU has many cores, don't hesitate to use the `-j` option to accelerate the build of the development environment. **CHECK** how many cores your CPU has before puttng a high value for the `-j` option. For example
```
./install -j 4
```

Now that this is done, it won't be needed for a second time.

To use the installed environment, the `setenv` file must be sourced
```
source setenv
```

To verify that the proper environment has been set, execute the following commands:
```
which gcc; which python; gcc -v; python -V
```
The ouput should point to the version installed this workspace in the `env` folder.

If everything is in order, move to install the Python dependencies.
```
pip install -r requirements
```