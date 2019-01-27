using Granite.Widgets;

namespace BookmarkManager {
public class App:Granite.Application{

    public static MainWindow window = null;
    public static GLib.Settings settings;

    construct {
        application_id = Constants.APPLICATION_NAME;
        program_name = Constants.APPLICATION_NAME;
        settings = new GLib.Settings (Constants.APPLICATION_NAME);
    }

    protected override void activate () {
        new_window ();
    }

    public static int main (string[] args) {
        var app = new BookmarkManager.App ();
        return app.run (args);
    }

    public void new_window () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow (this);
        go_to_last_saved_position (window);
        go_to_last_saved_size (window);

        window.show_all ();

        var listBox = ListBox.get_instance();
        listBox.getBookmarks("");
    }

    private void go_to_last_saved_position (MainWindow main_window) {
        int window_x, window_y;
        settings.get ("window-position", "(ii)", out window_x, out window_y);
        if (window_x != -1 || window_y != -1) {
            window.move (window_x, window_y);
        }
    }

    private void go_to_last_saved_size (MainWindow main_window) {
        var rect = Gtk.Allocation ();

        settings.get ("window-size", "(ii)", out rect.width, out rect.height);
        window.set_allocation (rect);

        if (settings.get_boolean ("window-maximized")) {
            window.maximize ();
        }
    }
}
}

