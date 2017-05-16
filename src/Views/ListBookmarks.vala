namespace BookmarkManager {
    public class ListBookmarks : Gtk.ScrolledWindow {
       
       public ListBookmarks(ListBox bookmarkBox){ 

            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            box.add(bookmarkBox);

            this.hscrollbar_policy = Gtk.PolicyType.NEVER;
            this.add (box);
        }
    }
}
