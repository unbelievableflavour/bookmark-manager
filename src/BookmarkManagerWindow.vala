using Granite.Widgets;

namespace BookmarkManager {
public class BookmarkManagerWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string LIST_VIEW_ID = "list-view";
    private Gtk.Stack stack;
    private int importIndex;
   
    construct {
        set_default_size(600, 500);
        set_size_request (600, 500);

        var header_bar = new Gtk.HeaderBar ();
        var searchEntry = new Gtk.SearchEntry ();

        header_bar.set_title ("Bookmark Manager");        
        header_bar.show_close_button = true;
        header_bar.pack_end (searchEntry);

        set_titlebar (header_bar);
        
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    
        var welcome_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
        var importIndex = welcome_view.append("document-open", "Import from SSH folder", "Load the .ssh/config file instead.");
        
        var bookmarkBox = new ListBox ();
        var bookmarkManager = new Bookmarks ();
        var bookmarks = bookmarkManager.getBookmarks();

        searchEntry.search_changed.connect (() => {
            bookmarks = bookmarkManager.getBookmarks();
            for (int a = 0; a < 15; a++) {
                if(searchEntry.text in bookmarks[a,1]){
                    print(bookmarks[a,1]);
                }
            }
        });

        for (int a = 0; a < 15; a++) {
            bookmarkBox.add (new ListBoxRow (bookmarks[a,1], bookmarks[a,2]));
        }        
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box.add(bookmarkBox);

          var list_view = new Gtk.ScrolledWindow (null, null);
            list_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
            list_view.add (box);
        welcome_view.activated.connect (on_welcome_view_activated);        
        
        stack.add_named (welcome_view, WELCOME_VIEW_ID);
        stack.add_named (list_view, LIST_VIEW_ID);
        add(stack);
    }

    private void on_welcome_view_activated (int index) {
        if(index == importIndex){
            stack.visible_child_name = LIST_VIEW_ID;
        }        
    }
} 
}
