using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

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

        var bookmarkManager = new Bookmarks ();
        var bookmarks = bookmarkManager.getBookmarks();

        for (int a = 0; a < 15; a++) {
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
