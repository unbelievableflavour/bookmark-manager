namespace BookmarkManager {
public class Alert : Gtk.Dialog {

    public Alert(string title, string description){
        resizable = false;
        deletable =  false;
        skip_taskbar_hint = true;
        transient_for = null;

        var image = generateImage();
        var primary_label = generateTitle(title);
        var secondary_label = generateDescription(description);

        var message_grid = new Gtk.Grid ();
        message_grid.column_spacing = 12;
        message_grid.row_spacing = 6;
        message_grid.margin_left = message_grid.margin_right = 12;
        message_grid.attach (image, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0, 1, 1);
        message_grid.attach (secondary_label, 1, 1, 1, 1);
        message_grid.show_all ();

        get_content_area ().add (message_grid);
        
        var close_button = generateCloseButton();

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        get_content_area ().add (button_box);
        this.show_all ();
    }

    public Gtk.Image generateImage(){
        var image = new Gtk.Image.from_icon_name ("dialog-warning", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;

        return image;
    }

    public Gtk.Label generateTitle(string title){
        var primary_label = new Gtk.Label (title);
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        return primary_label;
    }

    public Gtk.Label generateDescription(string description){
        var secondary_label = new Gtk.Label (description);
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        return secondary_label;
    }

    public Gtk.Button generateCloseButton(){
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        return close_button;
    }
}
}
