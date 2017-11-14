namespace BookmarkManager {
public class DeleteConfirm : Object {
      
    private ListBox listBox = ListBox.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    public DeleteConfirm(Bookmark deletedBookmark){
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (_("Delete this bookmark?"), _("Are you sure you want to delete this bookmark?"), "edit-delete", Gtk.ButtonsType.CANCEL);

        var suggested_button = new Gtk.Button.with_label ("Delete");
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

        message_dialog.show_all ();
        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {
            deleteBookmark(deletedBookmark);
        }
        message_dialog.destroy ();
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
        listBox.getBookmarks("");  
    }
}
}
