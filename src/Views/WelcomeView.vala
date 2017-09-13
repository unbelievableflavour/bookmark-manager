using Granite.Widgets;

namespace BookmarkManager {
public class WelcomeView : Gtk.ScrolledWindow {
 
    StackManager stackManager = StackManager.get_instance();

    public WelcomeView(){ 
        var welcome_view = new Welcome("Welcome!", "We see this is you're first time");
            welcome_view.append("document-properties", "Setup your information", "Change your ssh name, password, etc..");

        welcome_view.activated.connect ((option) => {
            switch (option) {		
                case 0:
                    setListView();
                    break;
            }
        });
        this.add(welcome_view);
    }

    private void setListView(){
        new Preferences ();
        stackManager.getStack().set_visible_child_name ("list-view");
    }
}
}
