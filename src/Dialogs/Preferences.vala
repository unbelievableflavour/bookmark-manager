namespace BookmarkManager {
    public class Preferences : Gtk.Dialog {
      
        private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    
        construct {
            title = "Preferences";
            set_default_size (630, 430);
            resizable = false;
            deletable = false;

            var general_header = new SettingsHeader ("General");
           
            var sshLabel = new Gtk.Label ("SSH name:");

            var sshEntry = new Gtk.Entry ();
            sshEntry.set_text (settings.get_string ("sshname"));

            // Close button
            var close_button = new Gtk.Button.with_label ("Close");
            close_button.clicked.connect (() => {
                settings.set_string("sshname", sshEntry.text);
                this.destroy ();

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
            general_grid.attach (sshLabel, 0, 1, 1, 1);
            general_grid.attach (sshEntry, 1, 1, 1, 1);
        
            // Pack everything into the dialog
            var main_grid = new Gtk.Grid ();
            main_grid.attach (general_grid, 0, 0, 1, 1);
            main_grid.attach (button_box, 0, 1, 1, 1);
            
            ((Gtk.Container) get_content_area ()).add (main_grid);
            this.show_all ();
        }
    }

    private class SettingsHeader : Gtk.Label {
        public SettingsHeader (string text) {
            label = text;
            get_style_context ().add_class ("h4");
            halign = Gtk.Align.START;
        }
    }
}
