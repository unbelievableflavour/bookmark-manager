using Granite.Widgets;

namespace BookmarkManager {
public class HeaderBar : Gtk.HeaderBar {

    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();
    
    public HeaderBar(){

        var searchEntry = new Gtk.SearchEntry ();
        searchEntry.set_placeholder_text("Search Bookmarks");
        searchEntry.set_tooltip_text("Search for bookmarks");
        searchEntry.search_changed.connect (() => {
            bookmarkListManager.getList().getBookmarks(searchEntry.text); 
        });

        var settings_button = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.LARGE_TOOLBAR);
        settings_button.set_tooltip_text("Change your preferences");
        settings_button.clicked.connect (() => {
            new Preferences ();
        });

        var add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_button.set_tooltip_text("Create a new bookmark");
        add_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "add-bookmark-view";
        });

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
      
        this.show_close_button = true;
        this.pack_start (add_button);
        this.pack_end (settings_button);        
        this.pack_end (searchEntry);
    }
}
}
