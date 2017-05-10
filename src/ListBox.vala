using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader bookmarkManager = new ConfigFileReader ();

    construct{
        expand = true;
    }

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        });    
    }

    public void getBookmarks(string searchWord = ""){
        this.empty();

        var bookmarks = bookmarkManager.getBookmarks();
        var bookmarksCount = bookmarkManager.countBookmarks();

        for (int a = 0; a < bookmarksCount; a++) {
            var bookmark = bookmarks[a];
        
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
