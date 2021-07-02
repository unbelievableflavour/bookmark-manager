namespace BookmarkManager {
public class StackManager : Object {

    static StackManager? instance;

    private Gtk.Stack stack;
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private const string EMPTY_VIEW_ID = "empty-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";
    private const string EDIT_BOOKMARK_VIEW_ID = "edit-bookmark-view";

    public Terminal terminal = new Terminal ();
    public static GLib.Settings settings;

    Gtk.Paned pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

    EditBookmark edit_bookmark_page;

    StackManager () {
        stack = new Gtk.Stack ();
        stack.get_style_context ().add_class ("stack-manager");
        settings = new GLib.Settings (Constants.APPLICATION_NAME);
        this.set_dark_mode (settings.get_boolean ("use-dark-theme"));
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }

    public void set_dark_mode (bool answer = true) {
        if (answer) {
           stack.get_style_context ().add_class ("stack-manager-dark");
        } else {
           stack.get_style_context ().remove_class ("stack-manager-dark");
        }
    }

    public static StackManager get_instance () {
        if (instance == null) {
            instance = new StackManager ();
        }
        return instance;
    }

    public Gtk.Stack get_stack () {
        return this.stack;
    }

    public void load_views (Gtk.Window window) {

        edit_bookmark_page = new EditBookmark ();

        stack.add_named (new EmptyView (), EMPTY_VIEW_ID);
        stack.add_named (new ListBookmarks (), LIST_VIEW_ID);
        stack.add_named (new AddBookmark (), ADD_BOOKMARK_VIEW_ID);
        stack.add_named (new NotFoundView (), NOT_FOUND_VIEW_ID);
        stack.add_named (edit_bookmark_page, EDIT_BOOKMARK_VIEW_ID);

        stack.notify["visible-child"].connect (() => {
            var header_bar = HeaderBar.get_instance ();

            if (stack.get_visible_child_name () == ADD_BOOKMARK_VIEW_ID) {
                header_bar.show_return_button (true);
                header_bar.show_add_button (false);
            }

            if (stack.get_visible_child_name () == LIST_VIEW_ID) {
                header_bar.search_entry.sensitive = true;
                header_bar.show_return_button (false);
                header_bar.show_add_button (true);
            }

            if (stack.get_visible_child_name () == EMPTY_VIEW_ID) {
                header_bar.search_entry.sensitive = true;
                header_bar.show_return_button (false);
                header_bar.show_add_button (true);
            }

            if (stack.get_visible_child_name () == NOT_FOUND_VIEW_ID) {
                header_bar.search_entry.sensitive = true;
                header_bar.show_return_button (false);
                header_bar.show_add_button (true);
            }

            if (stack.get_visible_child_name () == EDIT_BOOKMARK_VIEW_ID) {
                header_bar.show_return_button (true);
                header_bar.show_add_button (false);
            }
        });

        var pane = create_view_with_terminal ();
        window.add (pane);
   }

    public Gtk.Paned create_view_with_terminal () {
        terminal.expand = true;

        Gtk.ScrolledWindow result_box = new Gtk.ScrolledWindow (null, null);
        result_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        result_box.set_size_request (200, 200);
        result_box.add (stack);

        pane.expand = true;
        pane.pack2 (result_box, false, false);

        return pane;
    }

    public void set_edit_bookmark (Bookmark bookmark) {
        edit_bookmark_page.load_bookmark (bookmark);
    }

    public void add_a_terminal () {
        Gtk.ScrolledWindow view_box = new Gtk.ScrolledWindow (null, null);
        view_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        view_box.set_size_request (700, 200);
        view_box.add (terminal);

        pane.pack1 (view_box, true, false);
        pane.show_all ();
    }
}
}
