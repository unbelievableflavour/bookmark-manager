using Granite.Widgets;

namespace BookmarkManager {
public class HeaderBar : Gtk.HeaderBar {

    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();    
    public Gtk.SearchEntry searchEntry = new Gtk.SearchEntry ();
    Gtk.Button return_button = new Gtk.Button ();
    Gtk.Button add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.MenuButton menu_button = new Gtk.MenuButton ();

    public HeaderBar(){

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
        
        searchEntry.set_placeholder_text("Search Bookmarks");
        searchEntry.set_tooltip_text("Search for bookmarks");
        searchEntry.search_changed.connect (() => {
            showReturnButton(false);
            showAddButton(true);
            bookmarkListManager.getList().getBookmarks(searchEntry.text);
        });

        generateAddButton();
        generateMenuButton();
        generateReturnButton();

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
        this.pack_start (return_button);
        this.pack_end (menu_button);        
        this.pack_end (searchEntry);
    }

    private void generateMenuButton(){
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = ("Settings");
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
    }

    private void generateAddButton(){
        add_button.set_tooltip_text("Create a new bookmark");
        add_button.clicked.connect (() => {
            showReturnButton(true);
            showAddButton(false);
            stackManager.getStack().visible_child_name = "add-bookmark-view";            
        });
    }

    private void generateReturnButton(){
        return_button.label = "Back";
        return_button.no_show_all = true;
        return_button.get_style_context ().add_class ("back-button");
        return_button.visible = false;
        return_button.clicked.connect (() => {
            showReturnButton(false);
            showAddButton(true);
            stackManager.getStack().visible_child_name = "list-view";
            bookmarkListManager.getList().getBookmarks("");
        });
    }

    public void showSearchEntry(bool answer){
        searchEntry.visible = answer;
    }

    public void showAddButton(bool answer){
        add_button.visible = answer;
    }

    public void showReturnButton(bool answer){
        return_button.visible = answer;
    }
}
}
