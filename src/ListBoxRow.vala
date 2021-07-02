using Granite.Widgets;

namespace BookmarkManager {
public class ListBoxRow : Gtk.ListBoxRow {

    StackManager stack_manager = StackManager.get_instance ();
    private const int PROGRESS_BAR_HEIGHT = 5;
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    private Gtk.Image start_image = new Gtk.Image.from_icon_name (
        "media-playback-start-symbolic", Gtk.IconSize.SMALL_TOOLBAR
    );
    private Gtk.Image edit_image = new Gtk.Image.from_icon_name (
        "document-properties-symbolic", Gtk.IconSize.SMALL_TOOLBAR
    );
    private Gtk.Image delete_image = new Gtk.Image.from_icon_name (
        "edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR
    );
    private Gtk.Image icon = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
    private Bookmark bookmark;

    public ListBoxRow (Bookmark bookmark) {

        this.bookmark = bookmark;
        var ssh_command = generate_ssh_command (bookmark);
        var name_label = generate_name_label (bookmark);
        var summary_label = generate_summary_label (ssh_command);
        var start_button = generate_start_button (ssh_command);
        var edit_button = generate_edit_button (bookmark);
        var delete_button = generate_delete_button ();

        vertical_box.add (name_label);
        vertical_box.add (summary_label);

        var bookmark_row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        bookmark_row.margin = 12;
        bookmark_row.add (icon);
        bookmark_row.add (vertical_box);
        bookmark_row.pack_end (start_button, false, false);
        bookmark_row.pack_end (edit_button, false, false);
        bookmark_row.pack_end (delete_button, false, false);

        this.add (bookmark_row);
    }

    public Gtk.Label generate_name_label (Bookmark bookmark) {
        var name = bookmark.get_name ();
        if (bookmark.get_nickname () != null) {
            name = bookmark.get_nickname ();
        }
        var name_label = new Gtk.Label ("<b>%s</b>".printf (name));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;

        return name_label;
    }

    public Gtk.Label generate_summary_label (string ssh_command) {
        var summary_label = new Gtk.Label (ssh_command);
        summary_label.halign = Gtk.Align.START;

        return summary_label;
    }

    public string generate_ssh_command (Bookmark bookmark) {
        var username = settings.get_string ("sshname");
        if (bookmark.get_user () != null && bookmark.get_user () != "") {
            username = bookmark.get_user ();
        }

        return "ssh " + username + "@" + bookmark.get_name ();
    }

    public Gtk.EventBox generate_start_button (string ssh_command) {
        var start_button = new Gtk.EventBox ();
        start_button.add (start_image);
        start_button.set_tooltip_text (_("Start an SSH session in a terminal"));
        start_button.button_press_event.connect (() => {

            if (settings.get_boolean ("use-terminal")) {

                stack_manager.add_a_terminal ();

                try {
                    stack_manager.terminal.run_command (ssh_command);

                } catch (SpawnError e) {
                    new Alert ("An error occured", e.message);
                }
                return true;
            }

            try {
                var terminal_name = settings.get_string ("terminalname");
                Process.spawn_command_line_async (terminal_name + " --execute='" + ssh_command + "'");
            } catch (SpawnError e) {
                new Alert ("An error occured", e.message);
            }
            return true;
        });

        return start_button;
    }

    public Gtk.EventBox generate_delete_button () {
        var delete_button = new Gtk.EventBox ();
        delete_button.add (delete_image);
        delete_button.set_tooltip_text (_("Remote this bookmark"));
        delete_button.button_press_event.connect (() => {
            new DeleteConfirm (bookmark);
            return true;
        });

        return delete_button;
    }

    public Gtk.EventBox generate_edit_button (Bookmark bookmark) {
        var edit_button = new Gtk.EventBox ();
        edit_button.add (edit_image);
        edit_button.set_tooltip_text (_("Edit this bookmark"));
        edit_button.button_press_event.connect (() => {
            stack_manager.set_edit_bookmark (bookmark);
            stack_manager.get_stack ().visible_child_name = "edit-bookmark-view";
            return true;
        });

        return edit_button;
    }
}
}
