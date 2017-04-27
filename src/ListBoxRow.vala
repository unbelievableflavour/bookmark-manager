using Granite.Widgets;

namespace BookmarkManager {
public class ListBoxRow : Gtk.ListBoxRow {

    private const int PROGRESS_BAR_HEIGHT = 5;
    private Gtk.Label summary_label;
    private Gtk.Label name_label;
    private Gtk.Button button;
    private string sshName;

    construct {
        sshName = "bartz";

    }

    public ListBoxRow (string bookmarkName, string bookmarkIp){
        
        var package_image = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);        
        name_label = new Gtk.Label ("<b>%s</b>".printf (bookmarkName));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;            

        summary_label = new Gtk.Label (bookmarkIp);
        summary_label.halign = Gtk.Align.START;

        button = new Gtk.Button.with_label ("ssh");
        button.clicked.connect (() => {
            Process.spawn_command_line_async ("pantheon-terminal --execute='ssh "+sshName+"@"+bookmarkIp+"'");
        });

        var vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        vertical_box.add (name_label);
        vertical_box.add (summary_label);

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        button_box.margin = 12;
        button_box.add(package_image);            
        button_box.add (vertical_box);
        button_box.pack_end (button, false, false);

        var list_bow_row = new Gtk.ListBoxRow ();
        list_bow_row.add (button_box);
        list_bow_row.selectable = false;
        list_bow_row.activatable = false;

        add (list_bow_row);
    }
}
}
