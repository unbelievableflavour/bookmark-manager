namespace BookmarkManager {
public class DeleteConfirm : Gtk.Dialog {
      
    private BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

//    public DeleteConfirm(Bookmark deletedBookmark){
//        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name ("Delete this bookmark?", "Are you sure you want to delete this bookmark?", "edit-delete", Gtk.ButtonsType.CANCEL);
//        
//        var suggested_button = new Gtk.Button.with_label ("Delete");
//        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
//        message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);
//
//        message_dialog.show_all ();
//        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {
//            deleteBookmark(deletedBookmark);
//        }
//        message_dialog.destroy ();
//    }

    public DeleteConfirm(Bookmark deletedBookmark){
        var image = new Gtk.Image.from_icon_name ("edit-delete", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;

        var primary_label = new Gtk.Label ("Delete this bookmark?");
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        var secondary_label = new Gtk.Label ("Are you sure you want to delete this bookmark?");
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        var message_grid = new Gtk.Grid ();
        message_grid.column_spacing = 12;
        message_grid.row_spacing = 6;
        message_grid.margin_left = message_grid.margin_right = 12;
        message_grid.attach (image, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0, 1, 1);
        message_grid.attach (secondary_label, 1, 1, 1, 1);
        message_grid.show_all ();

        get_content_area ().add (message_grid);

        resizable = false;
        deletable =  false;
        skip_taskbar_hint = true;
        transient_for = null;
        
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var suggested_button = new Gtk.Button.with_label ("Delete"); 
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION); 
        
        suggested_button.clicked.connect (() => {
            deleteBookmark(deletedBookmark);
            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_start (suggested_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        get_content_area ().add (button_box);
        this.show_all ();
    }

    private void deleteBookmark(Bookmark deletedBookmark) {
        var ConfigFileReader = new ConfigFileReader(); 
        var bookmarks = ConfigFileReader.getBookmarks(); 
        Bookmark[] newBookmarksList = {};

        foreach (Bookmark bookmark in bookmarks) {
           if(bookmark.getName() != deletedBookmark.getName()) {
                newBookmarksList += bookmark;
           }
        }

        ConfigFileReader.writeToFile(newBookmarksList); 
         
        stackManager.getStack().visible_child_name = "list-view"; 
        bookmarkListManager.getList().getBookmarks("");  
    }
}
}
