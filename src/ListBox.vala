using Granite.Widgets;

namespace BookmarkManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader configFileReader = new ConfigFileReader ();
    private int emptyIndex;

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
            empty_view.activated.connect (on_empty_view_activated);            
            var emptyIndex = empty_view.append("document-new", "New bookmark", "add a new bookmark with host, ip, etc..");
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
    
    private void on_empty_view_activated (int index) {
        if(index == emptyIndex){
           
        }
    }
}
}
