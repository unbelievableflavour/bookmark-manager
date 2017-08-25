using Granite.Widgets;

namespace BookmarkManager {
public class ConfigFileReader : Gtk.ListBox{

   public Bookmark[] getBookmarks (){
        var bookmarksCount = countBookmarks();
        Bookmark[] bookmarks = new Bookmark[bookmarksCount];

        var file = File.new_for_path (Environment.get_home_dir () + "/.ssh/config");

        if (!file.query_exists ()) {
            stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
            return bookmarks;
        }
        
        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var dis = new DataInputStream (file.read ());
            string line;
            int i = 0;

            // Read lines until end of file (null) is reached
            while ((line = dis.read_line (null)) != null) {
                if("host" in line ){
                    i++;
                    bookmarks[i] = new Bookmark();
                    string host = getfilteredValueFromLine("host", line);
                    bookmarks[i].setName(host);
                }

                if("HostName" in line ){
                    string hostName = getfilteredValueFromLine("HostName", line);
                    bookmarks[i].setIp(hostName); 
                }

                if("Port" in line ){
                    int port = int.parse(getfilteredValueFromLine("Port", line));
                    bookmarks[i].setPort(port);                
                }

                if("User" in line ){
                    string user = getfilteredValueFromLine("User", line);
                    bookmarks[i].setUser(user);                     
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
        return File.new_for_path (path + "/.ssh/config");
    }
} 
}
