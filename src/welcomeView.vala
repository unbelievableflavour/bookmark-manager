using Granite.Widgets;

public class PackageRow : Gtk.ListBoxRow {

    private const int PROGRESS_BAR_HEIGHT = 5;
    private Gtk.Label summary_label;
    private Gtk.Label name_label;
    private Gtk.Button button;

    construct {

          var package_image = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);        
        name_label = new Gtk.Label ("<b>%s</b>".printf ("test01"));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;            

        summary_label = new Gtk.Label ("123.432.41.23");
        summary_label.halign = Gtk.Align.START;

        button = new Gtk.Button.with_label ("ssh");
        button.clicked.connect (() => {
                Process.spawn_command_line_async ("pantheon-terminal --execute='ssh bartz@10.42.34'");
            });

        var vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            vertical_box.add (name_label);
            vertical_box.add (summary_label);

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        
        button_box.margin = 12;
        button_box.add(package_image);            
        button_box.add (vertical_box);
        button_box.pack_end (button, false, false);

        var button_row = new Gtk.ListBoxRow ();
     
        button_row.add (button_box);
        button_row.selectable = false;
        button_row.activatable = false;



        add (button_row);
    }

}

public class BookmarkManagerWindow : Gtk.Window{

    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string LIST_VIEW_ID = "list-view";
    private Gtk.Stack stack;
    private int importIndex;
    private Gtk.ListBox list_box;
   
    construct {
        set_default_size(600, 500);
        set_size_request (600, 500);

        var header_bar = new Gtk.HeaderBar ();
        header_bar.set_title ("Bookmark Manager");
        header_bar.show_close_button = true;

        set_titlebar (header_bar);
        
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    
        var welcome_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
        var importIndex = welcome_view.append("document-open", "Import from SSH folder", "Load the .ssh/config file instead.");
            
        list_box = new Gtk.ListBox ();
        list_box.expand = true;
        list_box.add (new PackageRow ());
        
        var list_view = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        list_view.add(list_box);
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

public class SimpleGranite:Granite.Application{
   
    public override void activate() {
        
        var window = new BookmarkManagerWindow ();
        window.show_all();
    }

    public static int main(string[] args) {
    
        new SimpleGranite().run(args);
 
        Gtk.main();
 
        return 0;
    }
 
}
