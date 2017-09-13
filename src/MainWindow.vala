using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private const string EMPTY_VIEW_ID = "empty-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();
    StackManager stackManager = StackManager.get_instance();


    construct {
        set_default_size(600, 810);
        set_size_request (600, 810);
        set_titlebar (new HeaderBar());
       
        loadViews();        


        bookmarkListManager.getList().getBookmarks("");

        stackManager.getStack().visible_child_name = "list-view";

        if(settings.get_string ("sshname") == ""){
            stackManager.getStack().visible_child_name = "welcome-view";
        }

    }

    public void loadViews(){
        stackManager.getStack().add_named (new EmptyView(), EMPTY_VIEW_ID);
        stackManager.getStack().add_named (new ListBookmarks(), LIST_VIEW_ID);
        stackManager.getStack().add_named (new AddBookmark(), ADD_BOOKMARK_VIEW_ID);
        stackManager.getStack().add_named (new WelcomeView(), WELCOME_VIEW_ID);
        stackManager.getStack().add_named (new NotFoundView(), NOT_FOUND_VIEW_ID);

        add(stackManager.getStack());
        show_all();
    }
}
}
