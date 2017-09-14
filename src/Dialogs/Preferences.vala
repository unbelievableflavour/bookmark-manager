namespace BookmarkManager {
public class Preferences : Gtk.Dialog {
  
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

    public Preferences(){
        title = "Preferences";
        set_default_size (630, 430);
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel ("Preferences");
        
        var usernameLabel = new Gtk.Label ("Default Username:");
        var usernameEntry = new Gtk.Entry ();
        usernameEntry.set_text (settings.get_string ("sshname"));
        usernameEntry.set_tooltip_text ("This variable will be used when no variable is given in the ssh config");            

        var close_button = new Gtk.Button.with_label ("Close");
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var save_button = new Gtk.Button.with_label ("Save");
        save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        save_button.clicked.connect (() => {
            settings.set_string("sshname", usernameEntry.text);
            bookmarkListManager.getList().getBookmarks("");
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
    
        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);
        
        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }
}
}
