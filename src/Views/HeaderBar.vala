using Granite.Widgets;

namespace BookmarkManager {
public class HeaderBar : Gtk.HeaderBar {

    public HeaderBar(Gtk.Stack stack, ListBox listBox){

        var searchEntry = new Gtk.SearchEntry ();
        searchEntry.set_placeholder_text("Search Bookmarks");
        searchEntry.search_changed.connect (() => {
            listBox.getBookmarks(stack, searchEntry.text); 
        });

        var settings_button = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.LARGE_TOOLBAR);
        settings_button.clicked.connect (() => {
            new Preferences (stack, listBox);
        });

        var add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_button.clicked.connect (() => {
            stack.visible_child_name = "add-bookmark-view";
        });

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
      
        this.show_close_button = true;
        this.pack_start (add_button);
        this.pack_end (settings_button);        
        this.pack_end (searchEntry);
    }
}
}
