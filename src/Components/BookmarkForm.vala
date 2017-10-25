namespace BookmarkManager {
public class BookmarkForm : Gtk.Grid{
 
    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

    protected HeaderLabel general_header = new HeaderLabel ("A bookmark form");

    protected Gtk.Entry nicknameEntry = new BookmarkFormEntry ("if not set. Host is used");
    protected Gtk.Entry hostEntry = new BookmarkFormEntry ("server1");
    protected Gtk.Entry hostNameEntry = new BookmarkFormEntry ("127.0.0.1");
    protected Gtk.Entry userNameEntry = new BookmarkFormEntry ("james");
    protected Gtk.Entry portEntry = new BookmarkFormEntry ("80");
    protected Gtk.CheckButton agentForwardCheckButton = new BookmarkFormCheckButton();
    protected Gtk.Entry proxyCommandEntry = new BookmarkFormEntry ("ssh bookmark nc %h %p");

    protected Gtk.ButtonBox button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);

    public BookmarkForm(){

        var nicknameLabel = new BookmarkFormLabel ("Nickname:");
        var hostLabel = new BookmarkFormLabel ("Host:*");
        var hostNameLabel = new BookmarkFormLabel ("Host name:*");
        var userNameLabel = new BookmarkFormLabel ("Username:");
        var portLabel = new BookmarkFormLabel ("Port:");
        var agentForwardLabel = new BookmarkFormLabel ("Use agent forwarding:");
        var proxyCommandLabel = new BookmarkFormLabel ("Proxy command:");

        var back_button = new Gtk.Button.with_label ("Back");
        back_button.margin_right = 6;
        back_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "list-view";
            bookmarkListManager.getList().getBookmarks("");
        });

        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_end (back_button);
        button_box.margin_left = 12;
        button_box.margin_bottom = 0;

        column_homogeneous = true;
        row_spacing = 12;
        column_spacing = 12;
        margin = 12;

        attach (general_header, 0, 0, 2, 1);
        attach (nicknameLabel, 0, 1, 1, 1);
        attach (nicknameEntry, 1, 1, 1, 1);
        attach (hostLabel, 0, 2, 1, 1);
        attach (hostEntry, 1, 2, 1, 1);
        attach (hostNameLabel, 0, 3, 1, 1);
        attach (hostNameEntry, 1, 3, 1, 1);
        attach (userNameLabel, 0, 4, 1, 1);
        attach (userNameEntry, 1, 4, 1, 1);
        attach (portLabel, 0, 5, 1, 1);
        attach (portEntry, 1, 5, 1, 1);
        attach (agentForwardLabel, 0, 6, 1, 1);
        attach (agentForwardCheckButton, 1, 6, 1, 1);
        attach (proxyCommandLabel, 0, 7, 1, 1);
        attach (proxyCommandEntry, 1, 7, 1, 1);

        attach (button_box, 1, 8, 1, 1); 
    }

    public bool isNotValid(Bookmark newBookmark){
        if(newBookmark.getName() == "" || newBookmark.getIp() == ""){
            return true;
        }
        return false;
    }
}
}
