namespace BookmarkManager {
public class BookmarkForm : Gtk.Grid {

    protected HeaderLabel general_header = new HeaderLabel (_("A bookmark form"));

    protected Gtk.Entry nickname_entry = new BookmarkFormEntry (_("if not set. Host is used"));
    protected Gtk.Entry host_entry = new BookmarkFormEntry (_("server1"));
    protected Gtk.Entry host_name_entry = new BookmarkFormEntry (_("127.0.0.1"));
    protected Gtk.Entry username_entry = new BookmarkFormEntry (_("james"));
    protected Gtk.Entry port_entry = new BookmarkFormEntry (_("80"));
    protected Gtk.CheckButton agent_forward_check_button = new BookmarkFormCheckButton ();
    protected Gtk.Entry proxy_command_entry = new BookmarkFormEntry (_("ssh bookmark nc %h %p"));

    protected Gtk.ButtonBox button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);

    public BookmarkForm () {
        var nickname_label = new BookmarkFormLabel (_("Nickname:"));
        var host_label = new BookmarkFormLabel (_("Host:*"));
        var hostname_label = new BookmarkFormLabel (_("Host name:*"));
        var username_label = new BookmarkFormLabel (_("Username:"));
        var port_label = new BookmarkFormLabel (_("Port:"));
        var agent_forward_label = new BookmarkFormLabel (_("Use agent forwarding:"));
        var proxy_command_label = new BookmarkFormLabel (_("Proxy command:"));

        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.set_margin_start (12);
        button_box.margin_bottom = 0;

        column_homogeneous = true;
        row_spacing = 12;
        column_spacing = 12;
        margin = 12;

        attach (general_header, 0, 0, 2, 1);
        attach (nickname_label, 0, 1, 1, 1);
        attach (nickname_entry, 1, 1, 1, 1);
        attach (host_label, 0, 2, 1, 1);
        attach (host_entry, 1, 2, 1, 1);
        attach (hostname_label, 0, 3, 1, 1);
        attach (host_name_entry, 1, 3, 1, 1);
        attach (username_label, 0, 4, 1, 1);
        attach (username_entry, 1, 4, 1, 1);
        attach (port_label, 0, 5, 1, 1);
        attach (port_entry, 1, 5, 1, 1);
        attach (agent_forward_label, 0, 6, 1, 1);
        attach (agent_forward_check_button, 1, 6, 1, 1);
        attach (proxy_command_label, 0, 7, 1, 1);
        attach (proxy_command_entry, 1, 7, 1, 1);

        attach (button_box, 1, 8, 1, 1);
    }

    public bool is_not_valid (Bookmark new_bookmark) {
        if (new_bookmark.get_name () == "" || new_bookmark.get_ip () == "") {
            return true;
        }
        return false;
    }
}
}
