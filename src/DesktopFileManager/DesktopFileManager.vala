namespace BookmarkManager {
public class DesktopFileManager {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    public File get_backup_desktop_config_file () {
        var backup_file = File.new_for_path (
            "/usr/share/applications/com.github.bartzaalberg.bookmark-manager.backup"
        );
        if (!backup_file.query_exists ()) {
            try {
                var normal_file = get_desktop_config_file ();
                normal_file.copy (backup_file, 0, null);
                get_backup_desktop_config_file ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return backup_file;
    }

    public File get_desktop_config_file () {
        var file = File.new_for_path ("/usr/share/applications/com.github.bartzaalberg.bookmark-manager.desktop");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                get_desktop_config_file ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

    public void write_to_desktop_file (Bookmark[] bookmarks) {

        var backup_file = get_backup_desktop_config_file ();
        var lines = new DataInputStream (backup_file.read ());
        var normal_file = get_desktop_config_file ();
        var desktop_bookmarks_raw = "";
        string line;

        while ((line = lines.read_line (null)) != null) {
            if ("Actions=" in line) {
                desktop_bookmarks_raw += convert_bookmarks_to_actions_string (bookmarks) + "\n";
                continue;
            }
            desktop_bookmarks_raw += line + "\n";
        }

        desktop_bookmarks_raw += "\n";
        desktop_bookmarks_raw += convert_bookmarks_to_desktop_file_string (bookmarks);

        try {
            if (normal_file.query_exists () == true) {
                normal_file.delete (null);
                FileOutputStream fos = normal_file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);

                dos.put_string (desktop_bookmarks_raw, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private string convert_bookmarks_to_desktop_file_string (Bookmark[] bookmarks) {
        string raw_bookmarks_string = "";

        foreach (Bookmark bookmark in bookmarks) {
            string raw_bookmark = generate_ssh_command (bookmark);
            raw_bookmarks_string += raw_bookmark;
        }

        return raw_bookmarks_string;
    }

    private string convert_bookmarks_to_actions_string (Bookmark[] bookmarks) {
        string raw_bookmarks_string = "Actions=AboutDialog;";

        foreach (Bookmark bookmark in bookmarks) {
            raw_bookmarks_string += bookmark.get_name () + ";";
        }

        return raw_bookmarks_string;
    }

    public string generate_ssh_command (Bookmark bookmark) {
        var username = settings.get_string ("sshname");
        var terminal_name = settings.get_string ("terminalname");
        if (bookmark.get_user () != null && bookmark.get_user () != "") {
            username = bookmark.get_user ();
        }

        var action_string = "[Desktop Action " + bookmark.get_name () + "]\n";
        action_string += "Name=ssh " + bookmark.get_name () + "\n";
        action_string += "Exec=" + terminal_name + " --execute='ssh " + username + "@" + bookmark.get_name () + "'\n";
        action_string += "\n";

        return action_string;
    }
}
}
