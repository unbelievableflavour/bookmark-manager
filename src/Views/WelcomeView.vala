using Granite.Widgets;

namespace BookmarkManager {
public class WelcomeView : Gtk.ScrolledWindow {
 
    public WelcomeView(Gtk.Stack stack, ListBox listBox){ 
        var welcome_view = new Welcome("Welcome!", "We see this is you're first time");
            welcome_view.append("document-properties", "Setup your information", "Change your ssh name, password, etc..");

        welcome_view.activated.connect ((option) => {
            switch (option) {		
                case 0:
                    setListView(stack, listBox);
                    break;
            }
        });
        this.add(welcome_view);
    }

    private void setListView(Gtk.Stack stack, ListBox listBox){
        new Preferences (stack, listBox);
        stack.set_visible_child_name ("list-view");		
    }
}
}
