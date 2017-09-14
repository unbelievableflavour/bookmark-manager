using Granite.Widgets;

namespace BookmarkManager {
public class ConfigFileReader : Gtk.ListBox{

   public Bookmark[] getBookmarks (){
        Bookmark[] bookmarks = {};

        var file = getSshConfigFile();
        
        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());
            string line;

            // Read lines until end of file (null) is reached
            while ((line = lines.read_line (null)) != null) {
        
                if("host " in line ){
                    bookmarks += new Bookmark();

                    string host = getfilteredValueFromLine("host", line);
                    bookmarks[bookmarks.length - 1].setName(host);
                }
                
                if("Host " in line ){
                    bookmarks += new Bookmark();

                    string host = getfilteredValueFromLine("Host", line);
                    bookmarks[bookmarks.length - 1].setName(host);
                }

                if("hostName" in line ){
                    string hostName = getfilteredValueFromLine("hostName", line);
                    bookmarks[bookmarks.length - 1].setIp(hostName); 
                }

                if("HostName" in line ){
                    string hostName = getfilteredValueFromLine("HostName", line);
                    bookmarks[bookmarks.length - 1].setIp(hostName); 
                }

                if("port" in line ){
                    int port = int.parse(getfilteredValueFromLine("port", line));
                    bookmarks[bookmarks.length - 1].setPort(port);                
                }

                if("Port" in line ){
                    int port = int.parse(getfilteredValueFromLine("Port", line));
                    bookmarks[bookmarks.length - 1].setPort(port);                
                }

                if("user" in line ){
                    string user = getfilteredValueFromLine("user", line);
                    bookmarks[bookmarks.length - 1].setUser(user);                     
                }

                if("User" in line ){
                    string user = getfilteredValueFromLine("User", line);
                    bookmarks[bookmarks.length - 1].setUser(user);                     
                }
                
                if("forwardAgent" in line ){
                    string forwardAgent = getfilteredValueFromLine("forwardAgent", line);
                    bookmarks[bookmarks.length - 1].setForwardAgent(forwardAgent);
                }

                if("ForwardAgent" in line ){
                    string forwardAgent = getfilteredValueFromLine("ForwardAgent", line);
                    bookmarks[bookmarks.length - 1].setForwardAgent(forwardAgent);
                }
            }
               
           return bookmarks;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public string[] getOtherSettings (){
        string[] settings = new string[0];

        var file = getSshConfigFile();
        
        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());
            string line;

            // Read lines until end of file (null) is reached
            while ((line = lines.read_line (null)) != null) {
                if("host" in line || "Host" in line){
                    continue;
                }
                if("hostName" in line || "HostName" in line){
                    continue;
                }
                if("port" in line || "Port" in line){
                    continue;
                }
                if("User" in line || "user" in line){
                    continue;
                }

                if(line == ""){
                    continue;
                }
                settings += line;
            }

           return settings;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public int countBookmarks (){
        int count = 1;
        
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
            try {
                sshFolder.make_directory ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        var file = File.new_for_path (path + "/.ssh/config");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getSshConfigFile();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

    public void writeToFile(Bookmark[] bookmarks){
        var file = getSshConfigFile();

        try {
            if(file.query_exists() == true){
                var otherSettings = getOtherSettings();
                string bookmarksRaw = convertBookmarksToString(bookmarks);
                var otherSettingsRaw = convertOtherSettingsToString(otherSettings);

                file.delete(null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                
                dos.put_string (otherSettingsRaw + bookmarksRaw, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private string convertOtherSettingsToString(string[] settings){
        string rawSettingsString = "";
        
        for (int a = 0; a < settings.length; a++) {
            var setting = settings[a];
            string rawSetting = setting + "
";
            rawSettingsString += rawSetting;
        }

        rawSettingsString += "
";
        
        return rawSettingsString;
    }

    private string convertBookmarksToString(Bookmark[] bookmarks){
        string rawBookmarksString = "";
        
        for (int a = 0; a < bookmarks.length + 1; a++) {
            var bookmark = bookmarks[a];
            string rawBookmark = convertBookmarktoString(bookmark);
            rawBookmarksString += rawBookmark;
        }
        
        return rawBookmarksString;
    }

    private string convertBookmarktoString(Bookmark bookmark){
            string rawBookmark = "Host " + bookmark.getName(); 
 
            if(bookmark.getIp() != null){ 
                rawBookmark = rawBookmark + "
    HostName " + bookmark.getIp().to_string();
            }
       
            if(bookmark.getPort() != 0){ 
                rawBookmark = rawBookmark + "
    Port " + bookmark.getPort().to_string();
            }
     
            if(bookmark.getUser() != null){ 
                rawBookmark = rawBookmark + "
    User " + bookmark.getUser();
            }
            
            rawBookmark = rawBookmark + "

";
            return rawBookmark;
    }
}
}
