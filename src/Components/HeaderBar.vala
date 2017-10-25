using Granite.Widgets;

namespace BookmarkManager {
public class HeaderBar : Gtk.HeaderBar {

    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();    
    public Gtk.SearchEntry searchEntry = new Gtk.SearchEntry ();

    public HeaderBar(){

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
        
        searchEntry.set_placeholder_text("Search Bookmarks");
        searchEntry.set_tooltip_text("Search for bookmarks");
        searchEntry.search_changed.connect (() => {
            bookmarkListManager.getList().getBookmarks(searchEntry.text); 
        });

        var add_button = generateAddButton();
        var menu_button = generateMenuButton();

        var cheatsheet = new Gtk.MenuItem.with_label ("Markdown Cheatsheet");
        cheatsheet.activate.connect (() => {
            new Cheatsheet();
        });

        var preferences = new Gtk.MenuItem.with_label ("Preferences");
        preferences.activate.connect (() => {
            new Preferences();
        });

        var settings_menu = new Gtk.Menu ();
        settings_menu.add (cheatsheet);
        settings_menu.add (new Gtk.SeparatorMenuItem ());
        settings_menu.add (preferences);
        settings_menu.show_all ();

        menu_button.popup = settings_menu;

        this.show_close_button = true;
        this.pack_start (add_button);
        this.pack_end (menu_button);        
        this.pack_end (searchEntry);
    }

    private Gtk.MenuButton generateMenuButton(){
        var menu_button = new Gtk.MenuButton ();
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = ("Settings");
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
        return menu_button;
    }

    private Gtk.Button generateAddButton(){
        var add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_button.set_tooltip_text("Create a new bookmark");
        add_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "add-bookmark-view";
        });

        return add_button;
    }
}
}
