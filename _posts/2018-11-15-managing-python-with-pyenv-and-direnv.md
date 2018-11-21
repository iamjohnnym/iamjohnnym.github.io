---
layout: post
title: "Managing Python with Pyenv and Direnv"
date: 2018-11-15 11:00:00 -0800
author: iamjohnnym
tags:
  - python
  - pyenv
  - direnv
  - envrc
excerpt_separator: <!--more-->
---

Whether you're just getting started or you're a seasoned pythonista, pythoneer, or ${INSERT_YOUR_NOUN_HERE}, you've probably found managing your python environments to be tedious and rather painful.  Managing Python versions, libraries, and various dependencies is like playing shuffle board where the object is to not hit any other puck; if you do, the probability of a cascading effect of pucks flying everywhere you don't want them to be will soon follow.  Perhaps a (╯°□°)╯︵ uoɥʇʎd moment will occur.  Let's mitigate that.

**RELATED REPO** :: https://github.com/iamjohnnym/auto-pyvenv :: [![Build Status](https://travis-ci.com/iamjohnnym/auto-pyvenv.svg?branch=master)](https://travis-ci.com/iamjohnnym/auto-pyvenv)

<!--more-->

By the end of this article, we will be able to install any valid version of python, setup and configure virtual environments for each project, and bring sanity from chaos.

## ./prereqs

We're going to install both `pyenv` and `direnv` via `homebrew` to ease the install process.

- [homebrew](https://brew.sh/)

## ./objectives

- Install [pyenv](https://github.com/pyenv/pyenv)
  - Install Python 2.7.15
  - Install Python 3.7.0
- Install [direnv](https://direnv.net/)
- Set a local python version for a project
- Configure a virtualenv and mount a virtualenv by `cd`ing into the project dir

## ./pyenv

### ./pyenv --install
To get things started, we're going to install `pyenv`.

```bash
$ brew install pyenv
$ echo 'eval "$(pyenv init -)"' >> ~/.bashrc # initialize pyenv on new shells
$ source ~/.bashrc # reinitialize bashrc to reflect changes in your current shell
```

### ./pyenv --snapshot
Once it's installed, lets take a moment to examine what our environment looks like.  You should see something similar.

```bash
$ which pyenv
/usr/local/bin/pyenv
$ pyenv versions
* system
$ which pip
/usr/local/bin/pip
$ which python
/usr/local/bin/python
```

### ./pyenv --install
This is a pretty standard snapshot.  When you execute `pyenv versions`, you'll notice `* system`, as the reference implies, this is your systems python version.  A good rule of thumb is to leave the system binary alone, don't use it, don't play with it, just leave it.  If you want to see the list of python versions that `pyenv` can install for you, easy, `pyenv install --list`.  You'll find anything python `2.1.2`, please dont, `anaconda`, `miniconda`, and everything in-between.

```bash
$ pyenv install 2.7.15
$ pyenv install 3.7.0
$ pyenv versions
* system (set by /Users/iamjohnnym/.pyenv/version)
  2.7.15
  3.7.0
```

### ./pyenv --configure-base-requirements
Now, lets upgrade `pip` since chances are, it installed an older version.  Lets have bash do the work for us.  This will loop through your installed versions and update `pip` to the latest.

```bash
for VERSION in $(pyenv versions --bare) ; do
  pyenv shell ${VERSION} ;
  pip install --upgrade pip ;
done
```

For the sake of our desired workflow.  We want to install `py2venv` for our `Python 2.x` versions so we can mimic how `python 3.x` installs virtualenvs.  `python -m venv .venv`.

```bash
for VERSION in $(pyenv versions --bare | egrep '^2.') ; do
  pyenv shell ${VERSION} ;
  pip install py2venv ;
done
```

At the time of writing this, `pip==18.1` is the latest.

### ./pipenv --set-global
Even though we have `pyenv` installed, it will still default to `system`.  To change this, lets set `python 3.7.0` as our global version.

```bash
$ pyenv global 3.7.0
$ pyenv versions
  system
  2.7.15
* 3.7.0 (set by /Users/iamjohnnym/.pyenv/version)
$ which python
/Users/iamjohnnym/.pyenv/shims/python
```

Excellent.  We've got `pyenv` setup and functional.  Let's move on to `direnv`.

## ./direnv

What is `direnv`?  Great question.  Its a handy utility that allows you to create a file that's placed in any directory that you want that functions like `.bashrc`.  Whenever you enter the directory with this file, your shell will automagically execute it.  The capabilities are endless but for the purpose of this post, we're going to use it to configure a python virtualenv based on the file `.python-version` and then activate it for us.  The purpose is to create a seamless development flow.  No need to worry about manually  configuring or activating virtualenvs; let your computer do the work for you.

### ./direnv --install

Installation is straight-forward, much like `pyenv` but simpler.

```bash
$ brew install direnv
```

**BOOM**.  You're done, it's installed and ready for exploitation.  Let's harness that power.

## ./project

### ./project --init

Alright, we're almost done.  Let's start up a project.  We're going to create a new directory, set a local python version, set up our `.envrc` file, and activate it.

```bash
$ cd -p ~/python-projects/pyenv-tutorial
$ cd $_ # if you're unaware, $_ will execute the last argument of your command
$ pwd
/Users/iamjohnnym/ python-projects/pyenv-tutorial
$ pyenv local 3.7.0
$ cat .python-version
3.7.0
```

### ./direnv --python-auto-configure
At this point, we're ready to create our `.envrc` file.  With your favorite editor, create that file and add the following contents:

```bash
# check if python version is set in current dir
if [ -f ".python-version" ] ; then
    if [ ! -d ".venv" ] ; then
        echo "Installing virtualenv for $(python -V)"
        # if we didn't install `py2venv` for python 2.x, we would need to use
        # `virtualenv`, which you would have to install separately.
        python -m venv .venv
    fi
    echo "Activating $(python -V) virtualenv"
    source .venv/bin/activate
fi
# announce python version and show the path of the current python in ${PATH}
echo "Virtualenv has been activated for $(python -V)"
echo "$(which python)"
```

Save the file.  If you did this via a shell editor, such as `vim`.  You'll see the following message, `direnv: error .envrc is blocked. Run 'direnv allow' to approve its content.`  Don't be alarmed as this is a security feature to prevent auto-execution of the file.  Whenever this file is changed, it requires manual approval before it will auto-execute again.  To activate it, simply type `direnv allow` from the project dir.

### ./project --conclusion

```bash
$ direnv allow
direnv: loading .envrc
Installing virtualenv for Python 3.7.0
Activating Python 3.7.0 virtualenv
Virtualenv has been activated for Python 3.7.0
/Users/iamjohnnym/.personal/tutorials/pyenv-direnv/.venv/bin/python
direnv: export +VIRTUAL_ENV ~PATH
```

We're done.  That's it.  Everything we've ever needed to help maintain a semblence of sanity when working with different python versions and project dependencies!

**NOTE** if you would like a more robust `.envrc` file, one that will auto exec even if you don't declare a `.python-version` file or install the python version if it doesn't exist, use the following code block inside of your `.envrc` file.  It's a bit more comprehensive but the gist is this.

- Check if `.python-version` exists
  - Check if that version of python is not installed with `pyenv`
    - install python version
    - upgrade `pip` and `setuptools`
    - Check if python version is `2.x`
      - install `py2venv`
- Check if `.venv` does not exist
  - create venv
- Activate virtualenv

**the goods**

```bash
# .envrc
# check if python version is set in current dir
if [ -f ".python-version" ] ; then
    # ensure the python version is installed, if not, install it and configure
    # for compatibility with `auto-pyvenv`
    if [[ ! "$(pyenv versions | egrep $(cat .python-version))" ]] ; then
        echo -n "Python version not found, installing "
        echo "$(cat .python-version)"
        pyenv install "$(cat .python-version)"
        # rehash pyenv due to new install
        pyenv rehash
        # initial pyenv
        eval "$(pyenv init -)"
        echo "Upgrading pip to latest"
        pyenv shell $(cat .python-version)
        # upgrading setuptools in the event they are too old for `py2venv`
        pip install --upgrade pip setuptools
        if [ $(cat .python-version | egrep '^2.') ] ; then
            # `py2venv` allows you to install a virtualenv with
            # `python -m venv .venv`
            echo "Python 2.x detected.  Installing 'py2venv'"
            pip install py2venv
        fi
    fi
fi
# if a .venv dir doesn't exist, create one based on the current activated
# python version
if [ ! -d ".venv" ] ; then
    echo -n "Installing virtualenv for "
    echo "$(python -V)"
    python -m venv .venv
fi
# source the venv dir
echo -n "Activating virtualenv for "
echo "$(python -V)"
source .venv/bin/activate
echo "$(which python)"
```
