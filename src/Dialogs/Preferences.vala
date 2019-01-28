namespace BookmarkManager {
public class Preferences : Gtk.Dialog {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    private ListBox list_box = ListBox.get_instance ();

    public Preferences () {
        title = _("Preferences");
        set_default_size (630, 430);
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel (_("Preferences"));

        var usernameLabel = generate_label (_("Default Username:"));

        var username_entry = new Gtk.Entry ();
        username_entry.set_text (settings.get_string ("sshname"));
        username_entry.set_tooltip_text (_("This variable will be used when no variable is given in the ssh config"));

        var terminal_name_label = generate_label (_("Terminal:"));

        var terminal_name_entry = new Gtk.Entry ();
        terminal_name_entry.set_text (settings.get_string ("terminalname"));
        terminal_name_entry.set_tooltip_text (_("This is terminal used to start your ssh sessions"));

        var experimental_header = new HeaderLabel (_("Experimental"));

        var add_bookmarks_to_dock_update_label = generate_label (_("Add your bookmarks to your dock"));
        var add_bookmarks_to_dock_update_button = new Gtk.Button.with_label (_("Update Bookmarks"));
        add_bookmarks_to_dock_update_button.clicked.connect (() => {
           run_quick_list_updater ();
        });

        var use_terminal_label = generate_label (_("Use terminal inside app:"));
        var use_terminal = new Gtk.Switch ();
            use_terminal.halign = Gtk.Align.START;
            settings.bind ("use-terminal", use_terminal, "active", SettingsBindFlags.DEFAULT);

        var close_button = generate_close_button ();

        var save_button = new Gtk.Button.with_label (_("Save"));
        save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        save_button.clicked.connect (() => {
            if (username_entry.text == "") {
                settings.set_string ("sshname", Environment.get_user_name ());
            } else {
                settings.set_string ("sshname", username_entry.text);
            }

            if (terminal_name_entry.text == "") {
                settings.set_string ("terminalname", "io.elementary.terminal");
            }else {
                settings.set_string ("terminalname", terminal_name_entry.text);
            }

            list_box.get_bookmarks ("");
            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_end (save_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        var general_grid = new Gtk.Grid ();
        general_grid.row_spacing = 6;
        general_grid.column_spacing = 12;
        general_grid.margin = 12;
        general_grid.attach (general_header, 0, 0, 2, 1);
        general_grid.attach (usernameLabel, 0, 1, 1, 1);
        general_grid.attach (username_entry, 1, 1, 1, 1);

        general_grid.attach (terminal_name_label, 0, 2, 1, 1);
        general_grid.attach (terminal_name_entry, 1, 2, 1, 1);

        general_grid.attach (use_terminal_label, 0, 3, 1, 1);
        general_grid.attach (use_terminal, 1, 3, 1, 1);

        general_grid.attach (experimental_header, 0, 4, 2, 1);

        general_grid.attach (add_bookmarks_to_dock_update_label, 0, 5, 1, 1);
        general_grid.attach (add_bookmarks_to_dock_update_button, 1, 5, 1, 1);

        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);

        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }

    public bool is_not_valid (string input_field) {
        if (input_field == "") {
            return true;
        }
        return false;
    }

    public void run_quick_list_updater () {
        string result;
        string error;
        int status;

        try {
            Process.spawn_command_line_sync ("com.github.bartzaalberg.bookmark-manager-quicklist-polkit",
                                        out result,
                                        out error,
                                        out status);

            if (error != null && error != "" && status != 0) {
                new Alert (_("An error occured"), error);
            }else {
                var po_variable =
                    "Your bookmarks have been added to your dock.If you have added more" +
                    "bookmarks. Please click this button again, because it won't happen" +
                    " dynamically.";
                new Alert (_("Success"),_(po_variable));
            }

        } catch (SpawnError e) {
            new Alert (_("An error occured"), e.message);
        }
    }

    public Gtk.Label generate_label (string label_text) {
        var label = new Gtk.Label (label_text);
        label.halign = Gtk.Align.START;

        return label;
    }

    public Gtk.Button generate_close_button () {
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.margin_right = 6;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        return close_button;
    }
}
}
