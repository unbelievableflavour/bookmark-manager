using Granite.Widgets;

namespace BookmarkManager {
public class App:Granite.Application {

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
        use_dark_mode_if_enabled ();

        window.show_all ();

        var list_box = ListBox.get_instance ();
        list_box.get_bookmarks ("");
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

    private void use_dark_mode_if_enabled () {
       var gtk_settings = Gtk.Settings.get_default ();
        var dark_mode_switch = new Granite.ModeSwitch.from_icon_name (
            "display-brightness-symbolic", "weather-clear-night-symbolic"
        );
        dark_mode_switch.primary_icon_tooltip_text = _("Light mode");
        dark_mode_switch.secondary_icon_tooltip_text = _("Dark mode");
        dark_mode_switch.valign = Gtk.Align.CENTER;
        dark_mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        settings.bind ("use-dark-theme", dark_mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);
    }
}
}

