namespace BookmarkManager {
public class AddBookmark : BookmarkForm {

    private ListBox list_box = ListBox.get_instance ();
    ConfigFileReader config_file_reader = new ConfigFileReader ();

    public AddBookmark () {
        general_header.set_text (_("Add new bookmark"));

        var create_button = new Gtk.Button.with_label (_("Create"));
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        create_button.clicked.connect (() => {
           add_bookmark_to_file ();
        });

        button_box.pack_end (create_button);
    }

    private void add_bookmark_to_file () {
        var bookmark = new Bookmark ();
        bookmark.set_nickname (nickname_entry.text);
        bookmark.set_name (host_entry.text);
        bookmark.set_ip (host_name_entry.text);
        bookmark.set_user (username_entry.text);
        bookmark.set_port (int.parse (port_entry.text));

        if (agent_forward_check_button.active == true) {
           bookmark.set_forward_agent ("yes");
        }

        bookmark.set_proxy_command (proxy_command_entry.text);

        var bookmarks = config_file_reader.get_bookmarks ();

        if (is_not_valid (bookmark)) {
            new Alert (_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        if (already_exists (bookmark, bookmarks)) {
            new Alert (_("Bookmark with this name already exists"), _("Please choose a different name"));
            return;
        }

        bookmarks += bookmark;

        config_file_reader.write_to_file (bookmarks);

        list_box.get_bookmarks ("");
    }

    public bool already_exists (Bookmark new_bookmark, Bookmark[] bookmarks) {
        foreach (Bookmark bookmark in bookmarks) {
           if (bookmark.get_name () == new_bookmark.get_name ()) {
                return true;
           }
        }
        return false;
    }
}
}
