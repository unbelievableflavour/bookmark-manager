namespace BookmarkManager {
public class Alert : Gtk.Dialog {

    public Alert(string title, string description){

        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (title, description, "dialog-warning", Gtk.ButtonsType.CANCEL);
        message_dialog.show_all ();        
        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {}
        message_dialog.destroy ();
    }
}
}
