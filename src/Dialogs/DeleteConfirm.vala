namespace BookmarkManager {
public class DeleteConfirm : Object {

    private ListBox list_box = ListBox.get_instance ();
    private StackManager stack_manager = StackManager.get_instance ();

    public DeleteConfirm (Bookmark deleted_bookmark) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Delete this bookmark?"),
            _("Are you sure you want to delete this bookmark?"), "edit-delete", Gtk.ButtonsType.CANCEL
        );

        var suggested_button = new Gtk.Button.with_label ("Delete");
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

        message_dialog.show_all ();
        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {
            delete_bookmark (deleted_bookmark);
        }
        message_dialog.destroy ();
    }

    private void delete_bookmark (Bookmark deleted_bookmark) {
        var config_file_reader = new ConfigFileReader ();
        var bookmarks = config_file_reader.get_bookmarks ();
        Bookmark[] new_bookmarksList = {};

        foreach (Bookmark bookmark in bookmarks) {
           if (bookmark.get_name () != deleted_bookmark.get_name ()) {
                new_bookmarksList += bookmark;
           }
        }

        config_file_reader.write_to_file (new_bookmarksList);

        stack_manager.get_stack ().visible_child_name = "list-view";
        list_box.get_bookmarks ("");
    }
}
}
