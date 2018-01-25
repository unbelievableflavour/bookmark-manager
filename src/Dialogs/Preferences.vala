namespace BookmarkManager {
public class Preferences : Gtk.Dialog {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    private ListBox listBox = ListBox.get_instance();

    public Preferences(){
        title = _("Preferences");
        set_default_size (630, 430);
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel (_("Preferences"));

        var usernameLabel = generateLabel (_("Default Username:"));

        var usernameEntry = new Gtk.Entry ();
        usernameEntry.set_text (settings.get_string ("sshname"));
        usernameEntry.set_tooltip_text (_("This variable will be used when no variable is given in the ssh config"));

        var terminalNameLabel = generateLabel (_("Terminal:"));

        var terminalNameEntry = new Gtk.Entry ();
        terminalNameEntry.set_text (settings.get_string ("terminalname"));
        terminalNameEntry.set_tooltip_text (_("This is terminal used to start your ssh sessions"));

        var experimental_header = new HeaderLabel (_("Experimental"));

        var addBookmarksToDockUpdateLabel = generateLabel (_("Add your bookmarks to your dock"));
        var addBookmarksToDockUpdateButton = new Gtk.Button.with_label (_("Update Bookmarks"));
        addBookmarksToDockUpdateButton.clicked.connect (() => {
           runQuickListUpdater();
        });

        var use_terminal_label = generateLabel (_("Use terminal inside app:"));
        var use_terminal = new Gtk.Switch ();
            use_terminal.halign = Gtk.Align.START;
            settings.bind ("use-terminal", use_terminal, "active", SettingsBindFlags.DEFAULT);

        var close_button = generateCloseButton();

        var save_button = new Gtk.Button.with_label (_("Save"));
        save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        save_button.clicked.connect (() => {            
            if(usernameEntry.text ==  ""){
                settings.set_string ("sshname", Environment.get_user_name ());
            }else{
                settings.set_string("sshname", usernameEntry.text);
            }

            if(terminalNameEntry.text ==  ""){
                settings.set_string ("terminalname", "pantheon-terminal");
            }else{
                settings.set_string("terminalname", terminalNameEntry.text);
            }

            listBox.getBookmarks("");
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
        general_grid.attach (usernameEntry, 1, 1, 1, 1);

        general_grid.attach (terminalNameLabel, 0, 2, 1, 1);
        general_grid.attach (terminalNameEntry, 1, 2, 1, 1);

        general_grid.attach (experimental_header, 0, 3, 2, 1);
        general_grid.attach (addBookmarksToDockUpdateLabel, 0, 4, 1, 1);
        general_grid.attach (addBookmarksToDockUpdateButton, 1, 4, 1, 1);

        general_grid.attach (use_terminal_label, 0, 5, 1, 1);
        general_grid.attach (use_terminal, 1, 5, 1, 1);
    
        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);

        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }

    public bool isNotValid(string inputField){
        if(inputField ==  ""){
            return true;
        }
        return false;
    }

    public void runQuickListUpdater(){
        string result;
        string error;
        int status;

        try {
            Process.spawn_command_line_sync ("com.github.bartzaalberg.bookmark-manager-quicklist-polkit",
								        out result,
								        out error,
								        out status);

            if(error != null && error != "" && status != 0){
                new Alert(_("An error occured"), error);
            }else{
                new Alert(_("Success"),_("Your bookmarks have been added to your dock.If you have added more bookmarks. Please click this button again, because it won't happen dynamically."));
            }

        } catch (SpawnError e) {
            new Alert(_("An error occured"), e.message);
        }
    }

    public Gtk.Label generateLabel (string labelText){
        var label = new Gtk.Label (labelText);
        label.halign = Gtk.Align.START;

        return label;
    }

    public Gtk.Button generateCloseButton(){
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.margin_right = 6;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        return close_button;
    }
}
}
