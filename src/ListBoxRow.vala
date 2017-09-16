using Granite.Widgets;

namespace BookmarkManager {
public class ListBoxRow : Gtk.ListBoxRow {

    private const int PROGRESS_BAR_HEIGHT = 5;
    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager"); 

    private Gtk.Image start_image = new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR);
//    private Gtk.Image edit_image = new Gtk.Image.from_icon_name ("document-properties", Gtk.IconSize.SMALL_TOOLBAR);
    private Gtk.Image delete_image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

    private Gtk.Image icon = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);        
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
    private Bookmark bookmark;

    public ListBoxRow (Bookmark bookmark){
        
        this.bookmark = bookmark;
        var sshCommand = generateSSHCommand(bookmark);
        var name_label = generateNameLabel(bookmark);
        var summary_label = generateSummaryLabel(sshCommand);
        var start_button = generateStartButton(sshCommand);
        var delete_button = generateDeleteButton();

        vertical_box.add (name_label);
        vertical_box.add (summary_label);
        
        var bookmark_row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        bookmark_row.margin = 12;
        bookmark_row.add(icon);
        bookmark_row.add (vertical_box);
        bookmark_row.pack_end (start_button, false, false);
//        bookmark_row.pack_end (edit_image, false, false);
        bookmark_row.pack_end (delete_button, false, false);

        this.add (bookmark_row);
    }

    public Gtk.Label generateNameLabel(Bookmark bookmark){
        var name_label = new Gtk.Label ("<b>%s</b>".printf (bookmark.getName()));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;

        return name_label;
    }

    public Gtk.Label generateSummaryLabel(string sshCommand){
        var summary_label = new Gtk.Label (sshCommand);
        summary_label.halign = Gtk.Align.START;

        return summary_label;
    }

    public string generateSSHCommand(Bookmark bookmark){
        var username = settings.get_string("sshname"); 
        if(bookmark.getUser() != null){ 
            username = bookmark.getUser(); 
        }
 
        var port = 22; 
        if(bookmark.getPort() != 0){ 
            port = bookmark.getPort(); 
        }
 
        var ip = "127.0.0.1"; 
        if(bookmark.getIp() != null){ 
            ip = bookmark.getIp(); 
        }

        return "ssh " + username + "@" + ip + " -p " + port.to_string();     
    }

    public Gtk.EventBox generateStartButton(string sshCommand){
        var start_button = new Gtk.EventBox();
        start_button.add(start_image);
        start_button.set_tooltip_text("Start an SSH session");
        start_button.button_press_event.connect (() => {
            try {
                Process.spawn_command_line_async (
                    "pantheon-terminal --execute='" + sshCommand + "'"
                );
            } catch (SpawnError e) {
	            stdout.printf ("Error: %s\n", e.message);
            }
            return true;
        });    

        return start_button;
    }

    public Gtk.EventBox generateDeleteButton(){
        var delete_button = new Gtk.EventBox();
        delete_button.add(delete_image);
        delete_button.set_tooltip_text("Remote this bookmark");
        delete_button.button_press_event.connect (() => {
            new DeleteConfirm(bookmark);
            return true;
        });    

        return delete_button;
    }
}
}
