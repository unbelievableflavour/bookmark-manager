namespace BookmarkManager {
public class ConfigFileReader : Object{

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
                    continue;
                }
                if(bookmarks.length == 0){
                    continue;
                }
                if(inArray(variableOnLine, { "#nickname", "#Nickname" })){
                    bookmarks[bookmarks.length - 1].setNickname(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "hostName", "HostName" })){
                    bookmarks[bookmarks.length - 1].setIp(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "port", "Port" })){
                    bookmarks[bookmarks.length - 1].setPort(valueOnLine.to_int());
                    continue;
                }
                if(inArray(variableOnLine, { "user", "User" })){
                    bookmarks[bookmarks.length - 1].setUser(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "forwardAgent", "ForwardAgent" })){
                    bookmarks[bookmarks.length - 1].setForwardAgent(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "proxyCommand", "ProxyCommand" })){
                    bookmarks[bookmarks.length - 1].setProxyCommand(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "serverAliveInterval", "ServerAliveInterval" })){
                    bookmarks[bookmarks.length - 1].setServerAliveInterval(valueOnLine.to_int());
                    continue;
                }
                if(inArray(variableOnLine, { "logLevel", "LogLevel" })){
                    bookmarks[bookmarks.length - 1].setLogLevel(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "strictHostKeyChecking", "StrictHostKeyChecking" })){
                    bookmarks[bookmarks.length - 1].setStrictHostKeyChecking(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "userKnownHostsFile", "UserKnownHostsFile" })){
                    bookmarks[bookmarks.length - 1].setUserKnownHostsFile(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "visualHostKey", "VisualHostKey" })){
                    bookmarks[bookmarks.length - 1].setVisualHostKey(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "compression", "Compression" })){
                    bookmarks[bookmarks.length - 1].setCompression(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "localForward", "LocalForward" })){
                    bookmarks[bookmarks.length - 1].setLocalForward(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "remoteForward", "RemoteForward" })){
                    bookmarks[bookmarks.length - 1].setRemoteForward(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "dynamicForward", "DynamicForward" })){
                    bookmarks[bookmarks.length - 1].setDynamicForward(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "forwardX11", "ForwardX11" })){
                    bookmarks[bookmarks.length - 1].setForwardX11(valueOnLine);
                    continue;                
                }
                if(inArray(variableOnLine, { "identityFile", "IdentityFile" })){
                    bookmarks[bookmarks.length - 1].setIdentityFile(valueOnLine);
                    continue;                
                }
                if(inArray(variableOnLine, { "identitiesOnly", "IdentitiesOnly" })){
                    bookmarks[bookmarks.length - 1].setIdentitiesOnly(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "controlMaster", "ControlMaster" })){
                    bookmarks[bookmarks.length - 1].setControlMaster(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "controlPath", "ControlPath" })){
                    bookmarks[bookmarks.length - 1].setControlPath(valueOnLine);
                    continue;
                }
                if(inArray(variableOnLine, { "controlPersist", "ControlPersist" })){
                    bookmarks[bookmarks.length - 1].setControlPersist(valueOnLine);
                    continue;
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
                    break;
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

            if(elementsCount == 1 ) {
                filteredValue += part;
                elementsCount++;
                continue;
            }

            filteredValue += " " + part;
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

        if(bookmark.getNickname() != null && bookmark.getNickname() != ""){ 
            rawBookmark += "\n    #nickname " + bookmark.getNickname();
        }

        if(bookmark.getIp() != null){ 
            rawBookmark += "\n    HostName " + bookmark.getIp().to_string();
        }

        if(bookmark.getPort() != 0){ 
            rawBookmark += "\n    Port " + bookmark.getPort().to_string();
        }

        if(bookmark.getUser() != null && bookmark.getUser() != ""){ 
            rawBookmark += "\n    User " + bookmark.getUser();
        }

        if(bookmark.getForwardAgent() != null){ 
            rawBookmark += "\n    ForwardAgent " + bookmark.getForwardAgent();
        }

        if(bookmark.getProxyCommand() != null && bookmark.getProxyCommand() != ""){ 
            rawBookmark += "\n    ProxyCommand " + bookmark.getProxyCommand();
        }

        if(bookmark.getServerAliveInterval() != 0){ 
            rawBookmark += "\n    ServerAliveInterval " + bookmark.getServerAliveInterval().to_string();
        }

        if(bookmark.getLogLevel() != null && bookmark.getLogLevel() != ""){ 
            rawBookmark += "\n    LogLevel " + bookmark.getLogLevel();
        }

        if(bookmark.getStrictHostKeyChecking() != null && bookmark.getStrictHostKeyChecking() != ""){ 
            rawBookmark += "\n    StrictHostKeyChecking " + bookmark.getStrictHostKeyChecking();
        }

        if(bookmark.getUserKnownHostsFile() != null && bookmark.getUserKnownHostsFile() != ""){ 
            rawBookmark += "\n    UserKnownHostsFile " + bookmark.getUserKnownHostsFile();
        }

        if(bookmark.getVisualHostKey() != null && bookmark.getVisualHostKey() != ""){ 
            rawBookmark += "\n    VisualHostKey " + bookmark.getVisualHostKey();
        }

        if(bookmark.getCompression() != null && bookmark.getCompression() != ""){ 
            rawBookmark += "\n    Compression " + bookmark.getCompression();
        }

        if(bookmark.getLocalForward() != null && bookmark.getLocalForward() != ""){ 
            rawBookmark += "\n    LocalForward " + bookmark.getLocalForward();
        }

        if(bookmark.getRemoteForward() != null && bookmark.getRemoteForward() != ""){ 
            rawBookmark += "\n    RemoteForward " + bookmark.getRemoteForward();
        }

        if(bookmark.getDynamicForward() != null && bookmark.getDynamicForward() != ""){ 
            rawBookmark += "\n    DynamicForward " + bookmark.getDynamicForward();
        }

        if(bookmark.getForwardX11() != null && bookmark.getForwardX11() != ""){ 
            rawBookmark += "\n    ForwardX11 " + bookmark.getForwardX11();
        }

        if(bookmark.getIdentityFile() != null && bookmark.getIdentityFile() != ""){ 
            rawBookmark += "\n    IdentityFile " + bookmark.getIdentityFile();
        }

        if(bookmark.getIdentitiesOnly() != null && bookmark.getIdentitiesOnly() != ""){ 
            rawBookmark += "\n    IdentitiesOnly " + bookmark.getIdentitiesOnly();
        }

        if(bookmark.getControlMaster() != null && bookmark.getControlMaster() != ""){ 
            rawBookmark += "\n    ControlMaster " + bookmark.getControlMaster();
        }

        if(bookmark.getControlPath() != null && bookmark.getControlPath() != ""){ 
            rawBookmark += "\n    ControlPath " + bookmark.getControlPath();
        }

        if(bookmark.getControlPersist() != null && bookmark.getControlPersist() != ""){ 
            rawBookmark += "\n    ControlPersist " + bookmark.getControlPersist();
        }

        rawBookmark += "\n\n";
        return rawBookmark;
    }
}
}
