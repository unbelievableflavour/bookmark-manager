using Granite.Widgets;

namespace BookmarkManager {
public class App:Granite.Application{
   
    public override void activate() {
        var window = new BookmarkManagerWindow ();
        window.show_all();
    }

    public static int main(string[] args) {
    
        new App().run(args);

        Gtk.main();
 
        return 0;
    }
 
}
}

