using Granite.Widgets;

namespace BookmarkManager {
public class BookmarkManagerWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string CONFIG_VIEW_ID = "config-view";
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
        searchEntry.search_changed.connect (() => {     
            bookmarkBox.getBookmarks(searchEntry.text); 
        });
        var settings_button = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.LARGE_TOOLBAR);
        settings_button.clicked.connect (() => {
            stack.visible_child_name = CONFIG_VIEW_ID;        
        });

        //Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
      
        header_bar.show_close_button = true;
        header_bar.pack_end (settings_button);        
        header_bar.pack_end (searchEntry);        
          
        set_titlebar (header_bar);
        
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        var welcome_view = new Welcome("Welcome!", "We see this is you're first time");
        welcome_view.activated.connect (on_welcome_view_activated);
        var importIndex = welcome_view.append("document-properties", "Setup your information", "Change your ssh name, password, etc..");

        var empty_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
        //empty_view.activated.connect (on_empty_view_activated);
        //var empty_view = welcome_view.append("system-software-install", "Import from SSH folder", "Load the .ssh/config file instead."); 

        var list_view = setupListView();

        var config_view = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        var titleLabel = new Gtk.Label ("Settings");
        var sshLabel = new Gtk.Label ("SSH name");
        var sshEntry = new Gtk.Entry ();
        sshEntry.set_text (settings.get_string ("sshname"));
        var button = new Gtk.Button.with_label ("Save Settings");
        button.clicked.connect (() => {
            settings.set_string("sshname", sshEntry.text);
            stack.visible_child_name = LIST_VIEW_ID;        
        });
        
        config_view.add(titleLabel);
        config_view.add(sshLabel);
        config_view.add(sshEntry);
        config_view.add(button);

        if(settings.get_string ("sshname") == ""){
            stack.add_named (welcome_view, WELCOME_VIEW_ID);
        }
        
        stack.add_named (list_view, LIST_VIEW_ID);
        stack.add_named (config_view, CONFIG_VIEW_ID);
        add(stack);
    }
    
    //private void on_empty_view_activated (int index) {
    //    if(index == importIndex){    
    //        stack.visible_child_name = LIST_VIEW_ID;
    //    }
    //}

    private void on_welcome_view_activated (int index) {
        if(index == importIndex){    
            stack.visible_child_name = CONFIG_VIEW_ID;
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
