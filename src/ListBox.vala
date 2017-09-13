using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader configFileReader = new ConfigFileReader ();
    StackManager stackManager = StackManager.get_instance();

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        });    
    }

    public void getBookmarks(string searchWord = ""){
        this.empty();

        stackManager.getStack().visible_child_name = "list-view";

        var bookmarks = configFileReader.getBookmarks();

        if(bookmarks.length == 0){ 
            stackManager.getStack().visible_child_name = "empty-view";
        }

        int matchCount = 0;
        
        foreach (Bookmark bookmark in bookmarks) {
            if(searchWord != ""){
                if(searchWord in bookmark.getName()){
                    matchCount++;                
                    this.add (new ListBoxRow (bookmark));
                }
                
                continue;
            }          
            matchCount++;  
            this.add (new ListBoxRow (bookmark));
        }

        if(matchCount == 0){ 
            stackManager.getStack().visible_child_name = "not-found-view";
        }

        this.show_all();
    }
}
}
