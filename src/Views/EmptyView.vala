using Granite.Widgets;

namespace BookmarkManager {
public class EmptyView : Gtk.ScrolledWindow {

    StackManager stackManager = StackManager.get_instance();

    public EmptyView(){ 
        var empty_view = new Welcome("Add some bookmarks", "Your bookmarks file is empty.");
            empty_view.append("document-new", "New bookmark", "add a new bookmark with host, ip, etc..");

        empty_view.activated.connect ((option) => {
            switch (option) {		
                case 0:
                    setAddBookmarkView();
                    break;
            }
        });

        this.add(empty_view);
    }

    private void setAddBookmarkView(){
        stackManager.getStack().set_visible_child_name ("add-bookmark-view");		
    }
}
}
