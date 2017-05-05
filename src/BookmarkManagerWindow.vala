using Granite.Widgets;

namespace BookmarkManager {
public class BookmarkManagerWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string LIST_VIEW_ID = "list-view";
    private Gtk.Stack stack;
    private int importIndex;
    private ListBox bookmarkBox = new ListBox ();
   
    construct {
        set_default_size(600, 500);
        set_size_request (600, 500);

        var header_bar = new Gtk.HeaderBar ();

        var searchEntry = new Gtk.SearchEntry ();
        searchEntry.search_changed.connect (() => {     
            bookmarkBox.getBookmarks(searchEntry.text); 
        });

      
        header_bar.show_close_button = true;
        header_bar.pack_end (searchEntry);

        set_titlebar (header_bar);
        
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    
        var welcome_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
        welcome_view.activated.connect (on_welcome_view_activated);

        var importIndex = welcome_view.append("document-open", "Import from SSH folder", "Load the .ssh/config file instead."); 
        
        var list_view = setupListView();
        
        stack.add_named (welcome_view, WELCOME_VIEW_ID);
        stack.add_named (list_view, LIST_VIEW_ID);
        add(stack);
    }
    
    private void ListBoxForeachFunc (int index) {
        if(index == importIndex){
            stack.visible_child_name = LIST_VIEW_ID;
        }        
    }
    
    private void on_welcome_view_activated (int index) {
        if(index == importIndex){
            stack.visible_child_name = LIST_VIEW_ID;
        }        
    }

    private Gtk.ScrolledWindow setupListView(){
        bookmarkBox.getBookmarks();        

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box.add(bookmarkBox);

        var list_view = new Gtk.ScrolledWindow (null, null);
        list_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
        list_view.add (box);

        return list_view;     
    }
} 
}
