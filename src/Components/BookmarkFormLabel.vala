namespace BookmarkManager {
public class BookmarkFormLabel : Gtk.Label {

    public BookmarkFormLabel (string text) {
        label = text;
        halign = Gtk.Align.START;
    }
}
}
