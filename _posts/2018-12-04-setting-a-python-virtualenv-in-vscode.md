---
layout: post
title: "VSCode: How to Set a Custom Python Virtualenv Workspace"
date: 2018-12-04 11:00:00 -0800
author: iamjohnnym
tags:
  - python
  - vscode
  - virtualenv
excerpt_separator: <!--more-->
---

A common question I've come across, outside of how to manage Python environments, is how to make `VSCode` use your project's virtual environment.  The solution is easy.  The goal of this article is to configure a single project's `VSCode Workspace` to use a virtual environment.

<!--more-->

## ./table-of-contents
- [Prerequesites](#prerequs)
- [Objectives](#objectives)
- [VSCode](#vscode)
    - [Workspace Command Line](#workspace-command-line)
    - [Workspace within VSCode](#workspace-within-vscode)
- [Conclusion](#conclusion)


## ./prereqs
<small>[(Back to top)](#table-of-contents)</small>

* A python virtual environment
* VSCode IDE

## ./objectives
<small>[(Back to top)](#table-of-contents)</small>

* Configure a project workspace to use a python `virtualenv`
<br>
* Configure global settings to use a `virtualenv`

## ./vscode
<small>[(Back to top)](#table-of-contents)</small>

There's two ways that we can configure our workspace to leverage our `virtualenv`.  The first way, we can manually create the directory, the settings file, and the contents of the file tell `vscode` where to find our python interpreter.  The second way will be through the UI, which is also pretty straight forward.

Your project document root will contain a directory called, `.vscode`.  Inside of that directory is a `json` document called `settings.json`.  This is the file that we will be creating/modifying for your VSCode Workspace.

### ./workspace --command-line
<small>[(Back to top)](#table-of-contents)</small>

To get things started, navigate to your projects document root.  For the purpose of this article, our projects document root is located at `~/projects/vscode_workspace`.  Our virtualenv will reside within the project root in a directory called `.venv`, `~/projects/vscode_workspace/.venv`.  If you need some assistence on setting up a virtualenv, you can take a look at this article, [Managing python with pyenv and direnv](https://iamjohnnym.com/2018/11/15/managing-python-with-pyenv-and-direnv.html).  Go ahead and create your virtualenv too.

```bash
$ cd ~/projects/vscode_workspace
$ mkdir .vscode
$ python -m venv .venv
$ tree -a
.
├── .python-version
├── .venv
│   ├── bunch-of-python-files
└── .vscode
```

Excellent.  We have the minimal requirements to configure `VSCode` with our virtualenv.  Next, lets create the `settings.json` file that will tie them together!

```bash
$ echo <<EOF > ~/projects/vscode_workspace/.vscode/settings.json
{
    "python.pythonPath": ".venv/bin/python"
}
EOF
```

That's it.  You can now launch your project and your virtualenv will be configured for use in `VSCode`.

### ./workspace --within-vscode
<small>[(Back to top)](#table-of-contents)</small>

For some reason you don't want to set up `VSCode` to use your virtualenv with the previous method, you can still do it from within `VSCode` itself.  Go ahead and navigate to your project directory and set up your virtualenv.  Once complete, launch your project with `code .` or inside of `VSCode`.

On the menu bar, click on `Code` => `Preferences` => `Settings`.  This will launch a tab.  In this tab, click on `Workspace Settings`, and then on the far right side on the same row, click on `...` => `Open settings.json`.  This create yet another tab with a split window.  The left side will be a list of all default settings while the right hand side is your workspace settings.  If this is a fresh run, you will only see `{}` and nothing more.  The search bar is at the top.

In the search by, search for `python.pythonPath`.  Hover over the entry on the left hand side and click on the &#128394; => `Copy to settings`.  This will copy it to the right hand side, which is the file in `~/projects/vscode_workspace/.vscode/settings.json`.  Change the string from `python` to `.venv/bin/python`.  You should now have an entry that looks like so:

```bash
{
    "python.pythonPath": ".venv/bin/python"
}
```

### ./conclusion
<small>[(Back to top)](#table-of-contents)</small>

That's it.  Your `VSCode` is now using your project's virtualenv that you configured in your projects document root.  Ez pz lemon squeezy!
