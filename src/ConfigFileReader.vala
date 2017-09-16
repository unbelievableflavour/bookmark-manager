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

                var splittedLine = line.split(" ");
                string variableOnLine = getfilteredVariable(splittedLine);
                string valueOnLine = getfilteredValue(splittedLine);

                if(variableOnLine == null){continue;}
                
                if(inArray(variableOnLine, { "host", "Host" })){
                    bookmarks += new Bookmark();
                    bookmarks[bookmarks.length - 1].setName(valueOnLine);
                }

                if(inArray(variableOnLine, { "hostName", "HostName" })){
                    bookmarks[bookmarks.length - 1].setIp(valueOnLine); 
                }

                if(inArray(variableOnLine, { "port", "Port" })){
                    bookmarks[bookmarks.length - 1].setPort(valueOnLine.to_int());
                }

                if(inArray(variableOnLine, { "user", "User" })){
                    bookmarks[bookmarks.length - 1].setUser(valueOnLine);
                }
                
                if(inArray(variableOnLine, { "forwardAgent", "ForwardAgent" })){
                    bookmarks[bookmarks.length - 1].setForwardAgent(valueOnLine);
                }
                if(inArray(variableOnLine, { "proxyCommand", "ProxyCommand" })){
                    bookmarks[bookmarks.length - 1].setProxyCommand(valueOnLine);
                }
            }
               
           return bookmarks;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    bool inArray ( string needle, string[] haystack )  {
        if (needle in haystack) { 
            return true; 
        }
        return false;
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
                
                var splittedLine = line.split(" ");
                string variableOnLine = getfilteredVariable(splittedLine);

                if(line == "" || variableOnLine == null){
                    continue;
                }
                if(inArray(variableOnLine, { "host", "Host" })){
                    continue;
                }
                if(inArray(variableOnLine, { "hostName", "HostName" })){
                    continue;
                }                
                if(inArray(variableOnLine, { "port", "Port" })){
                    continue;
                }
                if(inArray(variableOnLine, { "user", "User" })){
                    continue;
                }
                if(inArray(variableOnLine, { "forwardAgent", "ForwardAgent" })){
                    continue;
                }
                if(inArray(variableOnLine, { "proxyCommand", "ProxyCommand" })){
                    continue;
                }
                settings += line;
            }

           return settings;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public string getfilteredVariable(string[] splittedLine){
        foreach (string part in splittedLine) {
            if(part == ""){
                continue;
            }
            return part;
        }
        return splittedLine[0];
    }

    public string getfilteredValue(string[] splittedLine){
        var elementsCount = 0;
        string filteredValue = "";
        foreach (string part in splittedLine) {
            if(part == ""){
                continue;  
            }          
            
            if(elementsCount == 0 ) {
                elementsCount++;
                continue;
            }

            filteredValue += part;
        }
        return filteredValue;
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
        
        foreach (string setting in settings) {
            string rawSetting = setting + "\n";
            rawSettingsString += rawSetting;
        }

        rawSettingsString += "\n";
        return rawSettingsString;
    }

    private string convertBookmarksToString(Bookmark[] bookmarks){
        string rawBookmarksString = "";
        
        foreach (Bookmark bookmark in bookmarks) { 
            string rawBookmark = convertBookmarktoString(bookmark);
            rawBookmarksString += rawBookmark;
        }
        
        return rawBookmarksString;
    }

    private string convertBookmarktoString(Bookmark bookmark){
            string rawBookmark = "Host " + bookmark.getName(); 
 
            if(bookmark.getIp() != null){ 
                rawBookmark = rawBookmark + "\n    HostName " + bookmark.getIp().to_string();
            }

            if(bookmark.getPort() != 0){ 
                rawBookmark = rawBookmark + "\n    Port " + bookmark.getPort().to_string();
            }

            if(bookmark.getUser() != null){ 
                rawBookmark = rawBookmark + "\n    User " + bookmark.getUser();
            }

            if(bookmark.getForwardAgent() != null){ 
                rawBookmark = rawBookmark + "\n    ForwardAgent " + bookmark.getForwardAgent();
            }

            if(bookmark.getProxyCommand() != null){ 
                rawBookmark = rawBookmark + "\n    ProxyCommand " + bookmark.getProxyCommand();
            }

            rawBookmark = rawBookmark + "\n\n";
            return rawBookmark;
    }
}
}
