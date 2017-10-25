namespace BookmarkManager {
public class BookmarkFormEntry : Gtk.Entry {
    
    public BookmarkFormEntry (string placeholder_text) {
        this.set_placeholder_text(placeholder_text);
        halign = Gtk.Align.FILL;
    }
}
}
