using Granite.Widgets;

namespace BookmarkManager {
public class Bookmark : Object {

    private string name;
    private string ip;
    private string user;
    private int port;

    public string getName(){
        return this.name;    
    }

    public void setName(string name){
        this.name = name;    
    }

    public string getIp(){
        return this.ip;    
    }

    public void setIp(string ip){
        this.ip = ip;
    }
    
    public string getUser(){
        return this.user;    
    }

    public string getPort(){
        return this.ip;    
    }
}
}
