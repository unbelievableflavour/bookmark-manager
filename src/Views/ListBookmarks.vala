namespace BookmarkManager {
public class ListBookmarks : Gtk.ScrolledWindow {
       
   BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

   public ListBookmarks(){ 

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box.add(bookmarkListManager.getList());

        this.hscrollbar_policy = Gtk.PolicyType.NEVER;
        this.add (box);
    }
}
}
