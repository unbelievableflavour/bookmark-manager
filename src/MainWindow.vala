using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private Gtk.Stack stack;
    private int importIndex;
    private ListBox bookmarkBox = new ListBox ();
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    construct {
        set_default_size(600, 500);
        set_size_request (600, 500);

        var header_bar = new Gtk.HeaderBar ();

        var searchEntry = new Gtk.SearchEntry ();
        searchEntry.set_placeholder_text("Search Bookmarks");
        searchEntry.search_changed.connect (() => {
            bookmarkBox.getBookmarks(searchEntry.text); 
        });
        var settings_button = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.LARGE_TOOLBAR);
        settings_button.clicked.connect (() => {
            new Preferences ();
        });

        var add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_button.clicked.connect (() => {
            stack.visible_child_name = ADD_BOOKMARK_VIEW_ID;
        });

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
      
        header_bar.show_close_button = true;
        header_bar.pack_start (add_button);
        header_bar.pack_end (settings_button);        
        header_bar.pack_end (searchEntry);
        set_titlebar (header_bar);
        
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        var welcome_view = new Welcome("Welcome!", "We see this is you're first time");
        welcome_view.activated.connect (on_welcome_view_activated);
        var importIndex = welcome_view.append("document-properties", "Setup your information", "Change your ssh name, password, etc..");

        //var empty_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
        //empty_view.activated.connect (on_empty_view_activated);
        //var empty_view = welcome_view.append("system-software-install", "Import from SSH folder", "Load the .ssh/config file instead."); 
        
        var add_bookmark_view = new AddBookmark(stack);
        bookmarkBox.getBookmarks(); 
        var list_view = new ListBookmarks(bookmarkBox);

        if(settings.get_string ("sshname") == ""){
            stack.add_named (welcome_view, WELCOME_VIEW_ID);
        }

        stack.add_named (list_view, LIST_VIEW_ID);
        stack.add_named (add_bookmark_view, ADD_BOOKMARK_VIEW_ID);
        add(stack);
    }
    
    //private void on_empty_view_activated (int index) {
    //    if(index == importIndex){    
    //        stack.visible_child_name = LIST_VIEW_ID;
    //    }
    //}

    private void on_welcome_view_activated (int index) {
        if(index == importIndex){
            stack.visible_child_name = LIST_VIEW_ID;
            new Preferences ();
        }
    }
}
}
