namespace BookmarkManager {
public class ListBookmarks : Gtk.ScrolledWindow {

    private ListBox list_box = ListBox.get_instance ();

    public ListBookmarks () {

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box.add (list_box);

        this.hscrollbar_policy = Gtk.PolicyType.NEVER;
        this.add (box);
    }
}
}
