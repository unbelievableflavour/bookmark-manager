namespace BookmarkManager {
public class AddBookmark : Gtk.Grid{
 
    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

    private Gtk.Entry hostEntry = new Gtk.Entry ();
    private Gtk.Entry hostNameEntry = new Gtk.Entry ();
    private Gtk.Entry userNameEntry = new Gtk.Entry ();
    private Gtk.Entry portEntry = new Gtk.Entry ();

    public AddBookmark(){ 
        var general_header = new HeaderLabel ("Add new bookmark");
       
        var hostLabel = new Gtk.Label ("Host:");
        hostLabel.set_alignment(0,0);

        var hostNameLabel = new Gtk.Label ("Host Name:");
        hostNameLabel.set_alignment(0,0);

        var userNameLabel = new Gtk.Label ("Username: (optional)");
        userNameLabel.set_alignment(0,0);
        
        var portLabel = new Gtk.Label ("Port: (optional)");
        portLabel.set_alignment(0,0);

        hostEntry.set_placeholder_text("server1");
        hostNameEntry.set_placeholder_text("127.0.0.1");
        userNameEntry.set_placeholder_text("james");
        portEntry.set_placeholder_text("80");

        var back_button = new Gtk.Button.with_label ("Back");
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
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        this.row_spacing = 12;
        this.column_spacing = 12;
        this.margin = 12;
        this.attach (general_header, 0, 0, 2, 1);
        this.attach (hostLabel, 0, 1, 1, 1);
        this.attach (hostEntry, 1, 1, 1, 1);
        this.attach (hostNameLabel, 0, 2, 1, 1);
        this.attach (hostNameEntry, 1, 2, 1, 1);
        this.attach (userNameLabel, 0, 3, 1, 1);
        this.attach (userNameEntry, 1, 3, 1, 1);
        this.attach (portLabel, 0, 4, 1, 1);
        this.attach (portEntry, 1, 4, 1, 1);

        this.attach (button_box, 1, 5, 1, 1);
        
    }

    public void AddBookmarkToFile(){
        var bookmark = new Bookmark();
           bookmark.setName(hostEntry.text);
           bookmark.setIp(hostNameEntry.text);  
           bookmark.setUser(userNameEntry.text);  
           bookmark.setPort(portEntry.text.to_int());  

           var ConfigFileReader = new ConfigFileReader();
           var bookmarks = ConfigFileReader.getBookmarks();

           if(isNotValid(bookmark)){
               new Alert("Fields are invalid", "Please correctly fill in all the fields");
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
