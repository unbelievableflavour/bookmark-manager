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

    public void getBookmarks(string searchWord = "", Gtk.Stack stack){
        this.empty();

        var bookmarks = configFileReader.getBookmarks();

        if(bookmarks.length == 0){
            var empty_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
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
