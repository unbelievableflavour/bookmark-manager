using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader configFileReader = new ConfigFileReader ();

    construct{
        expand = true;
    }

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        });    
    }

    public void getBookmarks(Gtk.Stack stack, string searchWord = ""){
        this.empty();

        var bookmarks = configFileReader.getBookmarks();

        if(bookmarks.length == 0){
            var empty_view = new EmptyView(stack);
            stack.add_named (empty_view, "empty-view");
        }

        foreach (Bookmark bookmark in bookmarks) {
            if(searchWord != ""){
                if(searchWord in bookmark.getName()){
                    this.add (new ListBoxRow (bookmark));
                }
                continue;
            }
            this.add (new ListBoxRow (bookmark));
        }

        this.show_all();
    }
}
}
