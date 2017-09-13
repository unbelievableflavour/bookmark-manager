using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader configFileReader = new ConfigFileReader ();
    private StackManager stackManager = StackManager.get_instance();

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        }); 
    }

    public void getBookmarks(string searchWord = ""){
        this.empty();

        stackManager.getStack().visible_child_name = "list-view";

        var bookmarks = configFileReader.getBookmarks();

        if(listisEmpty(bookmarks)) {
            stackManager.getStack().visible_child_name = "empty-view";
            return;
        }

        if(searchWordDoesntMatchAnyInList(searchWord, bookmarks)) {
            stackManager.getStack().visible_child_name = "not-found-view";
            return;
        }

        foreach (Bookmark bookmark in bookmarks) {
            if(searchWord == ""){
                this.add (new ListBoxRow (bookmark));
                continue;
            }

            if(searchWord in bookmark.getName()){             
                this.add (new ListBoxRow (bookmark));
            }            
        }

        this.show_all();
    }

    private bool listisEmpty(Bookmark[] bookmarks){
        return bookmarks.length == 0;    
    }

    private bool searchWordDoesntMatchAnyInList(string searchWord, Bookmark[] bookmarks){
        int matchCount = 0;
        
        if(searchWord == ""){
            return false;
        }

        foreach (Bookmark bookmark in bookmarks) {
            if(searchWord in bookmark.getName()){
                matchCount++;                
            }                
        }
        return matchCount == 0;    
    }
}
}
