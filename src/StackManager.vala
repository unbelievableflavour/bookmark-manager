namespace BookmarkManager {
public class StackManager : Object {
    
    static StackManager? instance;

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager"); 

    private Gtk.Stack stack;
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private const string EMPTY_VIEW_ID = "empty-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";
    private const string EDIT_BOOKMARK_VIEW_ID = "edit-bookmark-view";

    private string shell;
	private GLib.Pid child_pid;
    public Terminal terminal = new Terminal ();

    EditBookmark editBookmarkPage;

    // Private constructor
    StackManager() {
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }
 
    // Public constructor
    public static StackManager get_instance() {
        if (instance == null) {
            instance = new StackManager();
        }
        return instance;
    }

    public Gtk.Stack getStack() {
        return this.stack;
    }

    public void loadViews(Gtk.Window window){

        editBookmarkPage = new EditBookmark();

        stack.add_named (new EmptyView(), EMPTY_VIEW_ID);
        stack.add_named (new ListBookmarks(), LIST_VIEW_ID);
        stack.add_named (new AddBookmark(), ADD_BOOKMARK_VIEW_ID);
        stack.add_named (new NotFoundView(), NOT_FOUND_VIEW_ID);
        stack.add_named (editBookmarkPage, EDIT_BOOKMARK_VIEW_ID);

        if(settings.get_boolean("use-terminal")){
            var pane = createViewWithTerminal();
            window.add(pane);
        } else{
            window.add(stack);
        }

        window.show_all();
   }

    public Gtk.Paned createViewWithTerminal(){
        terminal.expand = true;
       
        Gtk.ScrolledWindow view_box = new Gtk.ScrolledWindow(null, null);
        view_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        view_box.set_size_request (700,200);
        view_box.add(terminal);

        Gtk.ScrolledWindow result_box = new Gtk.ScrolledWindow(null, null);
        result_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        result_box.set_size_request (200,200);
        result_box.add(stack);
        
        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            pane.expand = true;
            pane.pack1 (view_box, true, false);
            pane.pack2 (result_box, false, false);

        return pane;
    }

    public void setEditBookmark(Bookmark bookmark){
        editBookmarkPage.loadBookmark(bookmark);
    }
}
}
