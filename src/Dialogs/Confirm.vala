namespace BookmarkManager {
public class Confirm : Gtk.Dialog {
      
    private BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    public Confirm(){
        title = "Confirm";
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel ("Are You Sure?");
    
        var no_button = new Gtk.Button.with_label ("No");
        no_button.clicked.connect (() => {
            this.destroy ();
        });

        var yes_button = new Gtk.Button.with_label ("Yes");
        yes_button.clicked.connect (() => {
           var ConfigFileReader = new ConfigFileReader();

           var bookmarks = ConfigFileReader.getBookmarks();
           bookmarks.remove(bookmark);
           //ConfigFileReader.writeToFile(bookmarks);
            
           stackManager.getStack().visible_child_name = "list-view";
           bookmarkListManager.getList().getBookmarks(""); 
            
            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (no_button);
        button_box.pack_end (yes_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        var general_grid = new Gtk.Grid ();
        general_grid.row_spacing = 6;
        general_grid.column_spacing = 12;
        general_grid.margin = 12;
        general_grid.attach (general_header, 0, 0, 1, 1);
        general_grid.attach (button_box, 0, 1, 1, 1);

        ((Gtk.Container) get_content_area ()).add (general_grid);
        this.show_all ();
    }
}
}
