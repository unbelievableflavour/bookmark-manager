using Granite.Widgets;

namespace BookmarkManager {
public class MainWindow : Gtk.Window{

    private Settings settings = new Settings ("com.github.bartzaalberg.bookmark-manager");

    private ListBox listBox = ListBox.get_instance();
    private StackManager stackManager = StackManager.get_instance();
    private HeaderBar headerBar = HeaderBar.get_instance();

    construct {

        loadGresources();

        if(settings.get_string ("sshname") == ""){
           settings.set_string ("sshname", Environment.get_user_name ());
        }
        if(settings.get_string ("terminalname") == "" || settings.get_string ("terminalname") == "pantheon-terminal"){
           settings.set_string ("terminalname", "io.elementary.terminal");
        }

        set_default_size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
        set_titlebar (headerBar);

        stackManager.loadViews(this);

        listBox.getBookmarks("");

        addShortcuts();
    }

    private void loadGresources(){
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/bartzaalberg/bookmark-manager/application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    private void addShortcuts(){
        key_press_event.connect ((e) => {
            switch (e.keyval) {
                case Gdk.Key.a:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stackManager.getStack().visible_child_name = "add-bookmark-view";
                  }
                  break;
                case Gdk.Key.l:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stackManager.getStack().visible_child_name = "list-view";
                  }
                  break;
                case Gdk.Key.h:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    new Cheatsheet();
                  }
                  break;
                case Gdk.Key.f:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    headerBar.searchEntry.grab_focus();
                  }
                  break;
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    Gtk.main_quit();
                  }
                  break;
            }

            return false;
        });
    }
}
}
