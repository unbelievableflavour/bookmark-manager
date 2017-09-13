using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window{

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    private BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    construct {
        set_default_size(600, 810);
        set_size_request (600, 810);
        set_titlebar (new HeaderBar());
       
        stackManager.loadViews(this);

        bookmarkListManager.getList().getBookmarks("");

        stackManager.getStack().visible_child_name = "list-view";

        if(settings.get_string ("sshname") == ""){
            stackManager.getStack().visible_child_name = "welcome-view";
        }
    }
}
}
