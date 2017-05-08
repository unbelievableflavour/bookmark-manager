using Granite.Widgets;

namespace BookmarkManager {
public class ListBoxRow : Gtk.ListBoxRow {

    private const int PROGRESS_BAR_HEIGHT = 5;
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    private Gtk.Label summary_label;
    private Gtk.Label name_label;
    private Gtk.Button button = new Gtk.Button.with_label ("ssh");
    private Gtk.Image icon = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);        
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
    private Gtk.Box button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
    private Gtk.ListBoxRow list_bow_row = new Gtk.ListBoxRow ();

    public ListBoxRow (string bookmarkName, string bookmarkIp){
        
        name_label = new Gtk.Label ("<b>%s</b>".printf (bookmarkName));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;            

        summary_label = new Gtk.Label (bookmarkIp);
        summary_label.halign = Gtk.Align.START;

        button.clicked.connect (() => {
            try {
		        Process.spawn_command_line_async (
                    "pantheon-terminal --execute='ssh " + settings.get_string("sshname") + "@" + bookmarkIp + "'"
                );
	        } catch (SpawnError e) {
		        stdout.printf ("Error: %s\n", e.message);
	        }
        });

        vertical_box.add (name_label);
        vertical_box.add (summary_label);

        button_box.margin = 12;
        button_box.add(icon);
        button_box.add (vertical_box);
        button_box.pack_end (button, false, false);

        list_bow_row.add (button_box);
        list_bow_row.selectable = false;
        list_bow_row.activatable = false;

        add (list_bow_row);
    }
}
}
