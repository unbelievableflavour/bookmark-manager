namespace BookmarkManager {
public class DesktopFileManager {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    public File getBackupDesktopConfigFile(){
        var backupFile = File.new_for_path ("/usr/local/share/applications/com.github.bartzaalberg.bookmark-manager.backup");
        if (!backupFile.query_exists ()) {
            try {
                var normalFile = getDesktopConfigFile();
                normalFile.copy (backupFile, 0, null);
                getBackupDesktopConfigFile();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return backupFile;
    }

    public File getDesktopConfigFile(){
        var file = File.new_for_path ("/usr/local/share/applications/com.github.bartzaalberg.bookmark-manager.desktop");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getDesktopConfigFile();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

    public void writeToDesktopFile(Bookmark[] bookmarks){

        var backupFile = getBackupDesktopConfigFile();
        var lines = new DataInputStream (backupFile.read ());
        var normalFile = getDesktopConfigFile();
        var desktopBookmarksRaw = "";
        string line;

        while ((line = lines.read_line (null)) != null) {
            if("Actions=" in line){
                desktopBookmarksRaw += convertBookmarksToActionsString(bookmarks) + "\n";
                continue;
            }
            desktopBookmarksRaw += line + "\n";
        }

        desktopBookmarksRaw += "\n";
        desktopBookmarksRaw += convertBookmarksToDesktopFileString(bookmarks);

        try {
            if(normalFile.query_exists() == true){
                normalFile.delete(null);
                FileOutputStream fos = normalFile.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);

                dos.put_string (desktopBookmarksRaw, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private string convertBookmarksToDesktopFileString(Bookmark[] bookmarks){
        string rawBookmarksString = "";

        foreach (Bookmark bookmark in bookmarks) {
            string rawBookmark = generateSSHCommand(bookmark);
            rawBookmarksString += rawBookmark;
        }

        return rawBookmarksString;
    }

    private string convertBookmarksToActionsString(Bookmark[] bookmarks){
        string rawBookmarksString = "Actions=AboutDialog;";

        foreach (Bookmark bookmark in bookmarks) {
            rawBookmarksString += bookmark.getName() + ";";
        }

        return rawBookmarksString;
    }

    public string generateSSHCommand(Bookmark bookmark){
        var username = settings.get_string("sshname");
        var terminalName = settings.get_string("terminalname");
        if(bookmark.getUser() != null && bookmark.getUser() != ""){
            username = bookmark.getUser();
        }

        var actionString = "[Desktop Action " + bookmark.getName() + "]\n";
        actionString += "Name=ssh " + bookmark.getName() + "\n";
        actionString += "Exec=" + terminalName + " --execute='ssh " + username + "@" + bookmark.getName() + "'\n";
        actionString += "\n";

        return actionString;
    }
}
}
