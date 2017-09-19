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

### Dependencies

These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`

 You can install these on a Ubuntu-based system by executing this command:
 
 `sudo apt install valac libgtk-3-dev libgranite-dev`


### Building
```
mkdir build
cd build
sudo cmake ..
sudo make
```


### Installing
`sudo make install`
