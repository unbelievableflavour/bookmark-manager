using Granite.Widgets;

namespace BookmarkManager {
public class Bookmark : Object {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    private string name;
    private string ip;
    private string user;
    private int port;
    private string forwardAgent;

    public Bookmark() {
        setIp("127.0.0.1");
        setUser(settings.get_string("sshname"));
        setPort(22);
    }

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

    public void setUser(string user){
        this.user = user;    
    }

    public int getPort(){
        return this.port;    
    }

    public void setPort(int port){
        this.port = port;    
    }

    public string getForwardAgent(){
        return this.forwardAgent;    
    }

    public void setForwardAgent(string forwardAgent){
        this.forwardAgent = forwardAgent;    
    }
}
}
