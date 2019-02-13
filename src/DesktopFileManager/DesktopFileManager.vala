namespace BookmarkManager {
public class DesktopFileManager {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    public File get_backup_desktop_config_file () {
        var backupFile = File.new_for_path (
            "/usr/share/applications/com.github.bartzaalberg.bookmark-manager.backup"
        );
        if (!backupFile.query_exists ()) {
            try {
                var normal_file = get_desktop_config_file ();
                normal_file.copy (backupFile, 0, null);
                get_backup_desktop_config_file ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return backupFile;
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

        var backupFile = get_backup_desktop_config_file ();
        var lines = new DataInputStream (backupFile.read ());
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
        string raw_bookmarksString = "";

        foreach (Bookmark bookmark in bookmarks) {
            string raw_bookmark = generate_ssh_command (bookmark);
            raw_bookmarksString += raw_bookmark;
        }

        return raw_bookmarksString;
    }

    private string convert_bookmarks_to_actions_string (Bookmark[] bookmarks) {
        string raw_bookmarksString = "Actions=AboutDialog;";

        foreach (Bookmark bookmark in bookmarks) {
            raw_bookmarksString += bookmark.get_name () + ";";
        }

        return raw_bookmarksString;
    }

    public string generate_ssh_command (Bookmark bookmark) {
        var username = settings.get_string ("sshname");
        var terminalName = settings.get_string ("terminalname");
        if (bookmark.get_user () != null && bookmark.get_user () != "") {
            username = bookmark.get_user ();
        }

        var actionString = "[Desktop Action " + bookmark.get_name () + "]\n";
        actionString += "Name=ssh " + bookmark.get_name () + "\n";
        actionString += "Exec=" + terminalName + " --execute='ssh " + username + "@" + bookmark.get_name () + "'\n";
        actionString += "\n";

        return actionString;
    }
}
}
