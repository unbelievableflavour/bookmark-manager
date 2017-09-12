# Bookmark Manager
Manager for your ssh configs

![Screenshot](https://raw.githubusercontent.com/bartzaalberg/Bookmark-Manager/master/screenshot.png)

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
