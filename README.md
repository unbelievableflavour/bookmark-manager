# Bookmark Manager

### Simple App for elementary OS

A Vala application to get your ssh bookmarks from your config file

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
cmake ..
make
```


### Installing
`sudo make install`
