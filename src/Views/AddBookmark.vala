namespace BookmarkManager {
public class AddBookmark : BookmarkForm{
 
    private ListBox listBox = ListBox.get_instance();
    ConfigFileReader configFileReader = new ConfigFileReader();

    public AddBookmark(){
        general_header.set_text(_("Add new bookmark"));

        var create_button = new Gtk.Button.with_label (_("Create"));
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        create_button.clicked.connect (() => {
           AddBookmarkToFile();
        });

        button_box.pack_end (create_button);
    }

    public void AddBookmarkToFile(){
        var bookmark = new Bookmark();
        bookmark.setNickname(nicknameEntry.text);
        bookmark.setName(hostEntry.text);
        bookmark.setIp(hostNameEntry.text);  
        bookmark.setUser(userNameEntry.text);  
        bookmark.setPort(int.parse(portEntry.text));  

        if(agentForwardCheckButton.active == true) {
           bookmark.setForwardAgent("yes");
        }
             
        bookmark.setProxyCommand(proxyCommandEntry.text);  
       
        var bookmarks = configFileReader.getBookmarks();

        if(isNotValid(bookmark)){
            new Alert(_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        if(alreadyExists(bookmark, bookmarks)){
            new Alert(_("Bookmark with this name already exists"), _("Please choose a different name"));
            return;
        }

        bookmarks += bookmark;

        configFileReader.writeToFile(bookmarks);

        listBox.getBookmarks("");
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
