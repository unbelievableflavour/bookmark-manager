using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private Gtk.Stack stack;
    private ListBox listBox = new ListBox ();
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    construct {
        set_default_size(600, 810);
        set_size_request (600, 810);

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        set_titlebar (new HeaderBar(stack, listBox));
        
        listBox.getBookmarks(stack, ""); 

        var welcome_view = new WelcomeView(stack, listBox);
        var add_bookmark_view = new AddBookmark(stack, listBox);
        var list_view = new ListBookmarks(listBox);

        if(settings.get_string ("sshname") == ""){
            stack.add_named (welcome_view, WELCOME_VIEW_ID);
        }

        stack.add_named (list_view, LIST_VIEW_ID);
        stack.add_named (add_bookmark_view, ADD_BOOKMARK_VIEW_ID);
        add(stack);
    }
}
}
