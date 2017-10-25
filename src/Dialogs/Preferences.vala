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
                
        var usernameLabel = generateLabel ("Default Username:");

        var usernameEntry = new Gtk.Entry ();
        usernameEntry.set_text (settings.get_string ("sshname"));
        usernameEntry.set_tooltip_text ("This variable will be used when no variable is given in the ssh config");

        var experimental_header = new HeaderLabel ("Experimental");

        var addBookmarksToDockUpdateLabel = generateLabel ("Add your bookmarks to your dock");
        var addBookmarksToDockUpdateButton = new Gtk.Button.with_label ("Update Bookmarks");
        addBookmarksToDockUpdateButton.clicked.connect (() => {
           runQuickListUpdater();
        });

        var close_button = generateCloseButton();

        var save_button = new Gtk.Button.with_label ("Save");
        save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        save_button.clicked.connect (() => {
            
            if(isNotValid(usernameEntry.text)){
               new Alert("Fields are invalid", "Please correctly fill in all the fields");
               return;
            }

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

        general_grid.attach (experimental_header, 0, 2, 2, 1);
        general_grid.attach (addBookmarksToDockUpdateLabel, 0, 3, 1, 1);
        general_grid.attach (addBookmarksToDockUpdateButton, 1, 3, 1, 1);
    
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
                new Alert("An error occured",error);                
            }else{
                new Alert("Success","Your bookmarks have been added to your dock.If you have added more bookmarks. Please click this button again, because it won't happen dynamically.");
            }
	     
        } catch (SpawnError e) {
            new Alert("An error occured", e.message);
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
