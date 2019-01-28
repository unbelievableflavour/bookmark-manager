namespace BookmarkManager {
public class Cheatsheet : Gtk.Dialog {

    private HeaderLabel general_header = new HeaderLabel (_("Cheatsheet"));

    public Cheatsheet () {
        title = _("Cheatsheet");
        resizable = false;
        deletable = false;

        Gtk.Label[] labels = {};
        Gtk.Label[] shortcuts = {};

        labels += generate_label (_("Add bookmark"));
        shortcuts += generate_entry ("ctrl + a");

        labels += generate_label (_("List bookmarks"));
        shortcuts += generate_entry ("ctrl + l");

        labels += generate_label (_("Search"));
        shortcuts += generate_entry ("ctrl + f");

        labels += generate_label (_("Open the cheatsheet"));
        shortcuts += generate_entry ("ctrl + h");

        var close_button = generate_close_button ();

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        var cheatsheet_grid = generate_grid (shortcuts, labels);

        var main_grid = new Gtk.Grid ();
        main_grid.attach (cheatsheet_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);

        get_content_area ().add (main_grid);
        show_all ();
    }

    public Gtk.Grid generate_grid (Gtk.Label[] shortcuts, Gtk.Label[] labels) {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.margin = 12;
        grid.attach (general_header, 0, 0, 2, 1);

        var gridPosition = 1;
        var index = 0;

        foreach (Gtk.Label shortcut in shortcuts) {
            grid.attach (labels[index], 0, gridPosition, 1, 1);
            grid.attach (shortcuts[index], 1, gridPosition, 1, 1);

            gridPosition++;
            index++;
        }

        return grid;
    }

    public Gtk.Label generate_label (string label_text) {
        var label = new Gtk.Label (label_text);
        label.halign = Gtk.Align.START;

        return label;
    }

    public Gtk.Label generate_entry (string entry_text) {
        var entry = new Gtk.Label (null);
        entry.set_markup ("<b>" + entry_text + "</b>");

        return entry;
    }

    public Gtk.Button generate_close_button () {
        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.margin_right = 6;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        return close_button;
    }
}
}
