/*
* Copyright (c) 2011-2016 APP Developers (http://launchpad.net/APP)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Author <author@example.com>
*/

int main (string[] args) {
    Gtk.init (ref args);

    var window = new Gtk.Window ();
    window.title = "Bookmark Manager";
    window.set_border_width (12);
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (350, 70);
    window.destroy.connect (Gtk.main_quit);
    
    // A reference to our file
    string path = Environment.get_home_dir ();
    var file = File.new_for_path (path + "/.ssh/config");

    if (!file.query_exists ()) {
        stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
        return 1;
    }

    try {
        string name = "bartz";        
        // Open file for reading and wrap returned FileInputStream into a
        // DataInputStream, so we can read line by line
        var dis = new DataInputStream (file.read ());
        string line;
        
        int size = 15;
        string[,] bookmarks = new string[size,2];
       
        int i = 0;
        // Read lines until end of file (null) is reached        
        while ((line = dis.read_line (null)) != null) {
            if("host" in line ){
                string line_new = line.replace ("host", "");
                string line_newest = line_new.replace (" ", "");
                bookmarks[i,1] = line_newest;
            }

            if("    HostName" in line ){
                string line_new = line.replace ("HostName", "");
                string line_newest = line_new.replace (" ", "");                
                bookmarks[i,2] = line_newest;
                i++;
            }
        }
        var layout = new Gtk.Grid ();
        layout.column_spacing = 24;
        layout.row_spacing = 12;
        
       for (int a = 0; a < size; a++) {
            var button = new Gtk.Button.with_label (bookmarks[a,2]);
            var ip = bookmarks[a,2];
            
            button.clicked.connect (() => {
                Process.spawn_command_line_async ("pantheon-terminal --execute='ssh "+name+"@"+ip+"'");
            });
            var label = new Gtk.Label (bookmarks[a,1]);
            // add first row of widgets
            layout.attach (label, 0, a, 1, 1);
            layout.attach_next_to (button, label, Gtk.PositionType.RIGHT, 1, 1);

            //stdout.printf ("%s\n", bookmarks[a,1]);
            //stdout.printf ("%s\n", bookmarks[a,2]);
            //stdout.printf ("%s\n", "");
        }

        window.add(layout);
        window.show_all ();
       
    } catch (Error e) {
        error ("%s", e.message);
    }

    Gtk.main ();
    return 0;
}
