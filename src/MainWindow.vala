using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window {

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");
    private StackManager stack_manager = StackManager.get_instance ();
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private uint configure_id;

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {

        load_gresources ();

        if (settings.get_string ("sshname") == "") {
           settings.set_string ("sshname", Environment.get_user_name ());
        }
        if (settings.get_string ("terminalname") == "" || settings.get_string ("terminalname") == "pantheon-terminal") {
           settings.set_string ("terminalname", "io.elementary.terminal");
        }

        set_titlebar (header_bar);
        stack_manager.load_views (this);
        add_shortcuts ();
    }

    private void load_gresources () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/bartzaalberg/bookmark-manager/application.css");
        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    private void add_shortcuts () {
        key_press_event.connect ((e) => {
            switch (e.keyval) {
                case Gdk.Key.a:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stack_manager.get_stack ().visible_child_name = "add-bookmark-view";
                  }
                  break;
                case Gdk.Key.l:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stack_manager.get_stack ().visible_child_name = "list-view";
                  }
                  break;
                case Gdk.Key.h:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    new Cheatsheet ();
                  }
                  break;
                case Gdk.Key.s:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    new Preferences ();
                  }
                  break;
                case Gdk.Key.f:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    header_bar.search_entry.grab_focus ();
                  }
                  break;
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    this.destroy ();
                  }
                  break;
            }

            return false;
        });
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        var settings = new GLib.Settings (Constants.APPLICATION_NAME);

        if (configure_id != 0) {
            GLib.Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;

            if (is_maximized) {
                settings.set_boolean ("window-maximized", true);
            } else {
                settings.set_boolean ("window-maximized", false);

                Gdk.Rectangle rect;
                get_allocation (out rect);
                settings.set ("window-size", "(ii)", rect.width, rect.height);

                int root_x, root_y;
                get_position (out root_x, out root_y);
                settings.set ("window-position", "(ii)", root_x, root_y);
            }

            return false;
        });

        return base.configure_event (event);
    }
}
}
