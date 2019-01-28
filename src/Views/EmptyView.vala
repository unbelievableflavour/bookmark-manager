using Granite.Widgets;

namespace BookmarkManager {
public class EmptyView : Gtk.ScrolledWindow {

    StackManager stack_manager = StackManager.get_instance ();

    public EmptyView () {
        var empty_view = new Welcome (_("Add some bookmarks"), _("Your bookmarks file is empty."));
            empty_view.append ("document-new", _("New bookmark"), _("add a new bookmark with host, ip, etc.."));

        empty_view.activated.connect ((option) => {
            switch (option) {
                case 0:
                    set_add_bookmark_view ();
                    break;
            }
        });

        this.add (empty_view);
    }

    private void set_add_bookmark_view () {
        stack_manager.get_stack ().set_visible_child_name ("add-bookmark-view");
    }
}
}
