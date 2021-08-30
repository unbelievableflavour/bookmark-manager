<a href="https://gitlocalize.com/repo/4336"> <img src="https://gitlocalize.com/repo/4336/whole_project/badge.svg" /> </a>
<img src="https://travis-ci.org/bartzaalberg/bookmark-manager.svg?branch=master" />

# Archived
This repository is not maintained anymore and will not be updated to Elementary OS 6.0. You have my blessing to create a fork and update the application to post publish it in Elementary 6.0 under your own name. 

# Bookmark Manager
Manager for your ssh configs

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.bartzaalberg.bookmark-manager">
        <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
    </a>
</p>

<p align="center">
    <img 
    src="https://raw.githubusercontent.com/bartzaalberg/bookmark-manager/master/screenshot.png" />
</p>

### Simple App for elementary OS

A Vala application to get your ssh bookmarks from your config file and use them in an interface kinda way

## Installation

First you will need to install elementary SDK

 `sudo apt install elementary-sdk`

### Dependencies

These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`
 - `vte-2.91`

 You can install these on a Ubuntu-based system by executing this command:
 
 `sudo apt install valac libgtk-3-dev libgranite-dev vte-2.91`

### Building
```
meson build --prefix=/usr
cd build
ninja
```

### Installing
`sudo ninja install`

### Recompile the schema after installation
`sudo glib-compile-schemas /usr/share/glib-2.0/schemas`

### Update .pot file
Call the following command from the build folder:

`ninja com.github.bartzaalberg.bookmark-manager-pot`
