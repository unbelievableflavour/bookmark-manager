using Granite.Widgets;

namespace BookmarkManager {
public class HeaderBar : Gtk.HeaderBar {

    static HeaderBar? instance;

    StackManager stack_manager = StackManager.get_instance ();
    ListBox list_box = ListBox.get_instance ();
    public Gtk.SearchEntry search_entry = new Gtk.SearchEntry ();
    public Gtk.Button return_button = new Gtk.Button ();
    Gtk.Button add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.MenuButton menu_button = new Gtk.MenuButton ();
    Gtk.AccelGroup accel_group = new Gtk.AccelGroup ();

    HeaderBar () {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

        search_entry.set_placeholder_text (_("Search Bookmarks"));
        search_entry.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>F"}, _("Search for bookmarks"));
        search_entry.sensitive = true;
        search_entry.search_changed.connect (() => {
            show_return_button (false);
            show_add_button (true);
            list_box.get_bookmarks (search_entry.text);
        });

        generate_add_button ();
        generate_menu_button ();
        generate_return_button ();

        var cheatsheet = new Gtk.MenuItem.with_label (_("Markdown Cheatsheet"));
        cheatsheet.add_accelerator ("activate", accel_group,
            Gdk.Key.h, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
        cheatsheet.activate.connect (() => {
            new Cheatsheet ();
        });

        var preferences = new Gtk.MenuItem.with_label (_("Preferences"));
        preferences.add_accelerator ("activate", accel_group,
            Gdk.Key.s, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
        preferences.activate.connect (() => {
            new Preferences ();
        });

        var settings_menu = new Gtk.Menu ();
        settings_menu.add (cheatsheet);
        settings_menu.add (new Gtk.SeparatorMenuItem ());
        settings_menu.add (preferences);
        settings_menu.show_all ();

        menu_button.popup = settings_menu;

        this.show_close_button = true;
        this.pack_start (add_button);
        this.pack_start (return_button);
        this.pack_end (menu_button);
        this.pack_end (search_entry);
    }

    public static HeaderBar get_instance () {
        if (instance == null) {
            instance = new HeaderBar ();
        }
        return instance;
    }

    private void generate_menu_button () {
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = (_("Settings"));
        menu_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>S"}, _("Settings"));
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
    }

    private void generate_add_button () {

        add_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>A"}, _("Create a new bookmark"));
        add_button.clicked.connect (() => {
            stack_manager.get_stack ().visible_child_name = "add-bookmark-view";
        });
    }

    private void generate_return_button () {
        return_button.label = _("Back");
        return_button.no_show_all = true;
        return_button.get_style_context ().add_class ("back-button");
        return_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>L"}, _("Back to list"));
        return_button.visible = false;
        return_button.clicked.connect (() => {
            stack_manager.get_stack ().visible_child_name = "list-view";
            list_box.get_bookmarks ("");
        });
    }

    public void show_add_button (bool answer) {
        add_button.visible = answer;
    }

    public void show_return_button (bool answer) {
        return_button.visible = answer;
    }
}
}
