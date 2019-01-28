namespace BookmarkManager {
public class EditBookmark : BookmarkForm {

    private ListBox list_box = ListBox.get_instance ();

    public EditBookmark () {

        general_header.set_text (_("Edit a bookmark"));

        host_entry.set_sensitive (false);

        var edit_button = new Gtk.Button.with_label (_("Edit"));
        edit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        edit_button.clicked.connect (() => {
           edit_bookmarks_in_file ();
        });

        button_box.pack_end (edit_button);
    }

    public void load_bookmark (Bookmark bookmark) {

        nickname_entry.text = "";
        host_entry.text = "";
        host_name_entry.text = "";
        port_entry.text = "";
        username_entry.text = "";
        agent_forward_check_button.active = false;
        proxy_command_entry.text = "";

        if (bookmark.get_nickname () != null) {
            nickname_entry.text = bookmark.get_nickname ();
        }

        if (bookmark.get_name () != null) {
            host_entry.text = bookmark.get_name ();
        }
        if (bookmark.get_ip () != null) {
            host_name_entry.text = bookmark.get_ip ();
        }

        if (bookmark.get_port () != 0) {
            port_entry.text = bookmark.get_port ().to_string ();
        }

        if (bookmark.get_user () != null) {
            username_entry.text = bookmark.get_user ();
        }

        if (bookmark.get_forward_agent () != null) {
            agent_forward_check_button.active = true;
        }

        if (bookmark.get_proxy_command () != null) {
            proxy_command_entry.text = bookmark.get_proxy_command ();
        }
    }

    public void edit_bookmarks_in_file () {

        var bookmark_name = host_entry.text;

        var config_file_reader = new ConfigFileReader ();
        var bookmarks = config_file_reader.get_bookmarks ();

        var bookmark = get_correct_bookmark_by_name (bookmark_name, bookmarks);
        bookmark.set_nickname (nickname_entry.text);
        bookmark.set_name (host_entry.text);
        bookmark.set_ip (host_name_entry.text);
        bookmark.set_user (username_entry.text);
        bookmark.set_port (int.parse (port_entry.text));

        if (agent_forward_check_button.active == true) {
            bookmark.set_forward_agent ("yes");
        }

        bookmark.set_proxy_command (proxy_command_entry.text);

        if (is_not_valid (bookmark)) {
            new Alert (_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        var index = get_correct_bookmark_index (bookmark, bookmarks);

        bookmarks[index] = bookmark;

        config_file_reader.write_to_file (bookmarks);

        list_box.get_bookmarks ("");
    }

    public int get_correct_bookmark_index (Bookmark edited_bookmark, Bookmark[] bookmarks) {
        var index = 0;
        foreach (Bookmark bookmark in bookmarks) {
            if (bookmark.get_name () == edited_bookmark.get_name ()) {
                return index;
            }
            index++;
        }
        return index;
    }

    public Bookmark get_correct_bookmark_by_name (string bookmark_name, Bookmark[] bookmarks) {
        foreach (Bookmark bookmark in bookmarks) {
            if (bookmark.get_name () == bookmark_name) {
                return bookmark;
            }
        }
        return new Bookmark ();
    }
}
}
