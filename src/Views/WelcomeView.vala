using Granite.Widgets;

namespace BookmarkManager {
public class WelcomeView : Gtk.ScrolledWindow {

    StackManager stack_manager = StackManager.get_instance ();

    public WelcomeView () {
        var welcome_view = new Welcome (_("Welcome!"), _("We see this is your first time"));
        welcome_view.append (
            "document-properties",
            _("Setup your information"),
            _("Change your ssh name, password, etc..")
        );

        welcome_view.activated.connect ((option) => {
            switch (option) {
                case 0:
                    set_list_view ();
                    break;
            }
        });
        this.add (welcome_view);
    }

    private void set_list_view () {
        new Preferences ();
        stack_manager.get_stack ().set_visible_child_name ("list-view");
    }
}
}
