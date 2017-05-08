using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private Bookmarks bookmarkManager = new Bookmarks ();

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
            if(searchWord != ""){
                if(searchWord in bookmarks[a,1]){
                    this.add (new ListBoxRow (bookmarks[a,1], bookmarks[a,2]));
                }
                continue;
            }
            this.add (new ListBoxRow (bookmarks[a,1], bookmarks[a,2]));                        
        }

        this.show_all();
    }
}
}
