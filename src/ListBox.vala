using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox {

    static ListBox? instance;

    private ConfigFileReader config_file_reader = new ConfigFileReader ();
    private StackManager stack_manager = StackManager.get_instance ();

    ListBox () {
    }

    public static ListBox get_instance () {
        if (instance == null) {
            instance = new ListBox ();
        }
        return instance;
    }

    public void empty_list () {
        this.foreach ((ListBoxRow) => {
            this.remove (ListBoxRow);
        });
    }

    public void get_bookmarks (string search_word = "") {
        empty_list ();

        stack_manager.get_stack ().visible_child_name = "list-view";

        var bookmarks = config_file_reader.get_bookmarks ();

        if (list_is_empty (bookmarks)) {
            HeaderBar.get_instance ().search_entry.sensitive = false;
            stack_manager.get_stack ().visible_child_name = "empty-view";
            return;
        }

        if (search_word_doesnt_match_any_in_list (search_word, bookmarks)) {
            stack_manager.get_stack ().visible_child_name = "not-found-view";
            return;
        }

        foreach (Bookmark bookmark in bookmarks) {
            if (search_word == "") {
                add (new ListBoxRow (bookmark));
                continue;
            }

            if (search_word in bookmark.get_name ()) {
                add (new ListBoxRow (bookmark));
            }
        }

        show_all ();
    }

    private bool list_is_empty (Bookmark[] bookmarks) {
        return bookmarks.length == 0;
    }

    private bool search_word_doesnt_match_any_in_list (string search_word, Bookmark[] bookmarks) {
        int matchCount = 0;

        if (search_word == "") {
            return false;
        }

        foreach (Bookmark bookmark in bookmarks) {
            if (search_word in bookmark.get_name ()) {
                matchCount++;
            }
        }
        return matchCount == 0;
    }
}
}
