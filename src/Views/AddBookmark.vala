namespace BookmarkManager {
public class AddBookmark : Gtk.Grid{
 
    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

    private Gtk.Entry nicknameEntry = new Gtk.Entry ();
    private Gtk.Entry hostEntry = new Gtk.Entry ();
    private Gtk.Entry hostNameEntry = new Gtk.Entry ();
    private Gtk.Entry userNameEntry = new Gtk.Entry ();
    private Gtk.Entry portEntry = new Gtk.Entry ();
    private Gtk.CheckButton agentForwardCheckButton = new Gtk.CheckButton();
    private Gtk.Entry proxyCommandEntry = new Gtk.Entry ();

    public AddBookmark(){ 

        var general_header = new HeaderLabel ("Add new bookmark");
       
        var nicknameLabel = new Gtk.Label ("Nickname:");
        nicknameLabel.halign = Gtk.Align.START;

        var hostLabel = new Gtk.Label ("Host:*");
        hostLabel.halign = Gtk.Align.START;

        var hostNameLabel = new Gtk.Label ("Host name:*");
        hostNameLabel.halign = Gtk.Align.START;

        var userNameLabel = new Gtk.Label ("Username:");
        userNameLabel.halign = Gtk.Align.START;
        
        var portLabel = new Gtk.Label ("Port:");
        portLabel.halign = Gtk.Align.START;

        var agentForwardLabel = new Gtk.Label ("Use agent forwarding:");
        agentForwardLabel.halign = Gtk.Align.START;
        
        var proxyCommandLabel = new Gtk.Label ("Proxy command:");
        proxyCommandLabel.halign = Gtk.Align.START;

        nicknameEntry.set_placeholder_text("if not set. Host is used");
        nicknameEntry.halign = Gtk.Align.FILL;
        hostEntry.set_placeholder_text("server1");
        hostEntry.halign = Gtk.Align.FILL;
        hostNameEntry.set_placeholder_text("127.0.0.1");
        hostNameEntry.halign = Gtk.Align.FILL;
        userNameEntry.set_placeholder_text("james");
        userNameEntry.halign = Gtk.Align.FILL;
        portEntry.set_placeholder_text("80");
        portEntry.halign = Gtk.Align.FILL;
        proxyCommandEntry.set_placeholder_text("ssh bookmark nc %h %p");
        proxyCommandEntry.halign = Gtk.Align.FILL;
        agentForwardCheckButton.halign = Gtk.Align.FILL;

        var back_button = new Gtk.Button.with_label ("Back");
        back_button.margin_right = 6;
        back_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "list-view";
            bookmarkListManager.getList().getBookmarks("");
        });

        var create_button = new Gtk.Button.with_label ("Create");
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        create_button.clicked.connect (() => {
           AddBookmarkToFile();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_end (back_button);
        button_box.pack_end (create_button);
        button_box.margin_left = 12;
        button_box.margin_bottom = 0;
        button_box.halign = Gtk.Align.END;

        this.column_homogeneous = true;
        this.row_spacing = 12;
        this.column_spacing = 12;
        this.margin = 12;

        this.attach (general_header, 0, 0, 2, 1);
        this.attach (nicknameLabel, 0, 1, 1, 1);
        this.attach (nicknameEntry, 1, 1, 1, 1);
        this.attach (hostLabel, 0, 2, 1, 1);
        this.attach (hostEntry, 1, 2, 1, 1);
        this.attach (hostNameLabel, 0, 3, 1, 1);
        this.attach (hostNameEntry, 1, 3, 1, 1);
        this.attach (userNameLabel, 0, 4, 1, 1);
        this.attach (userNameEntry, 1, 4, 1, 1);
        this.attach (portLabel, 0, 5, 1, 1);
        this.attach (portEntry, 1, 5, 1, 1);
        this.attach (agentForwardLabel, 0, 6, 1, 1);
        this.attach (agentForwardCheckButton, 1, 6, 1, 1);
        this.attach (proxyCommandLabel, 0, 7, 1, 1);
        this.attach (proxyCommandEntry, 1, 7, 1, 1);

        this.attach (button_box, 1, 8, 1, 1);   
    }

    public void AddBookmarkToFile(){
        var bookmark = new Bookmark();
        bookmark.setNickname(nicknameEntry.text);
        bookmark.setName(hostEntry.text);
        bookmark.setIp(hostNameEntry.text);  
        bookmark.setUser(userNameEntry.text);  
        bookmark.setPort(portEntry.text.to_int());  

        if(agentForwardCheckButton.active == true) {
           bookmark.setForwardAgent("yes");
        }
             
        bookmark.setProxyCommand(proxyCommandEntry.text);  

        var ConfigFileReader = new ConfigFileReader();
        var bookmarks = ConfigFileReader.getBookmarks();

        if(isNotValid(bookmark)){
            new Alert("Fields are invalid", "Please correctly fill in all the required fields");
            return;
        }

        if(alreadyExists(bookmark, bookmarks)){
            new Alert("Bookmark with this name already exists", "Please choose a different name");
            return;
        }

        bookmarks += bookmark;

        ConfigFileReader.writeToFile(bookmarks);

        stackManager.getStack().visible_child_name = "list-view";
        bookmarkListManager.getList().getBookmarks("");    
    }

    public bool isNotValid(Bookmark newBookmark){
        if(newBookmark.getName() == "" || newBookmark.getIp() == ""){
            return true;
        }
        return false;
    }

    public bool alreadyExists(Bookmark newBookmark, Bookmark[] bookmarks){
        foreach (Bookmark bookmark in bookmarks) {
           if(bookmark.getName() == newBookmark.getName()) {
                return true;
           }
        }
        return false;
    }
}
}
