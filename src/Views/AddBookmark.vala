namespace BookmarkManager {
    public class AddBookmark : Gtk.ScrolledWindow{
 
        public AddBookmark(Gtk.Stack stack){ 
            var general_header = new SettingsHeader ("General");
           
            var hostLabel = new Gtk.Label ("Host:");
            var hostNameLabel = new Gtk.Label ("Host Name:");

            var hostEntry = new Gtk.Entry ();
            hostEntry.set_placeholder_text("server1");

            var hostNameEntry = new Gtk.Entry ();
            hostNameEntry.set_placeholder_text("127.0.0.1");

            // Close button
            var close_button = new Gtk.Button.with_label ("Create");
            close_button.clicked.connect (() => {
                stack.visible_child_name = "list-view";

            });

            var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
            button_box.set_layout (Gtk.ButtonBoxStyle.END);
            button_box.pack_end (close_button);
            button_box.margin = 12;
            button_box.margin_bottom = 0;

            // add the preferences to a grid
            var general_grid = new Gtk.Grid ();
            general_grid.row_spacing = 6;
            general_grid.column_spacing = 12;
            general_grid.margin = 12;
            general_grid.attach (general_header, 0, 0, 2, 1);
            general_grid.attach (hostLabel, 0, 1, 1, 1);
            general_grid.attach (hostEntry, 1, 1, 1, 1);
            general_grid.attach (hostNameLabel, 0, 2, 1, 1);
            general_grid.attach (hostNameEntry, 1, 2, 1, 1);
        
            // Pack everything into the dialog
            // Pack everything into the dialog
            var main_grid = new Gtk.Grid ();
            main_grid.attach (general_grid, 0, 0, 1, 1);
            main_grid.attach (button_box, 0, 1, 1, 1);
            
            this.add (main_grid);
        }
    }
}