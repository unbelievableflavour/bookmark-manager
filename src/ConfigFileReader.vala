using Granite.Widgets;

namespace BookmarkManager {
public class ConfigFileReader : Gtk.ListBox{

   public Bookmark[] getBookmarks (){
        var bookmarksCount = countBookmarks();
        Bookmark[] bookmarks = new Bookmark[bookmarksCount];

        var file = getSshConfigFile();

        if (!file.query_exists ()) {
            stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
            return bookmarks;
        }
        
        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());
            string line;
            int currentBookmarkIndex = 0;
            // Read lines until end of file (null) is reached
            while ((line = lines.read_line (null)) != null) {
                if("host " in line ){
                    currentBookmarkIndex++;
                    bookmarks[currentBookmarkIndex] = new Bookmark();
                    string host = getfilteredValueFromLine("host", line);
                    bookmarks[currentBookmarkIndex].setName(host);
                }

                if("Host " in line ){
                    currentBookmarkIndex++;
                    bookmarks[currentBookmarkIndex] = new Bookmark();
                    string host = getfilteredValueFromLine("Host", line);
                    bookmarks[currentBookmarkIndex].setName(host);
                }

                if("hostName" in line ){
                    string hostName = getfilteredValueFromLine("hostName", line);
                    bookmarks[currentBookmarkIndex].setIp(hostName); 
                }

                if("HostName" in line ){
                    string hostName = getfilteredValueFromLine("HostName", line);
                    bookmarks[currentBookmarkIndex].setIp(hostName); 
                }

                if("Port" in line ){
                    int port = int.parse(getfilteredValueFromLine("Port", line));
                    bookmarks[currentBookmarkIndex].setPort(port);                
                }

                if("User" in line ){
                    string user = getfilteredValueFromLine("User", line);
                    bookmarks[currentBookmarkIndex].setUser(user);                     
                }
            }
            
           return bookmarks;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public int countBookmarks (){
        int count = 0;
        
        var file = getSshConfigFile();

        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());
            
            string line;
            // Read lines until end of file (null) is reached        
            while ((line = lines.read_line (null)) != null) {
                if("host" in line ){
                    count++;
                }
            }
           return count;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }
    
    public string getfilteredValueFromLine(string value, string line){
        string line_new = line.replace (value, "");

        return line_new.replace (" ", "");
    }

    private File getSshConfigFile(){
        string path = Environment.get_home_dir ();

        var sshFolder = File.new_for_path (path + "/.ssh/");
        if (!sshFolder.query_exists ()) {
            sshFolder.make_directory ();
        }

        var file = File.new_for_path (path + "/.ssh/config");
        if (!file.query_exists ()) {
            FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);            
            DataOutputStream dos = new DataOutputStream (fos); 

            getSshConfigFile();
        }
        return file;
    }
} 
}
