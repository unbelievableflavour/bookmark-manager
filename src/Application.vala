using Granite.Widgets;

namespace BookmarkManager {
public class App:Granite.Application{
   
    construct {
        application_id = Constants.APPLICATION_ID;
        program_name = Constants.APP_NAME;
        app_years = "2017-2018";
        exec_name = Constants.EXEC_NAME;
        app_launcher = Constants.DESKTOP_NAME;

        build_version = Constants.VERSION;
        app_icon = "com.github.bartzaalberg.bookmark-manager";
        main_url = "https://github.com/bartzaalberg/Bookmark-Manager";
        bug_url = "https://github.com/bartzaalberg/Bookmark-Manager/issues";
    }

    public override void activate() {
        var window = new MainWindow ();
        window.destroy.connect (Gtk.main_quit);
        window.show_all();
    }

    public static int main(string[] args) {
    
        new App().run(args);

        Gtk.main();
 
        return 0;
    }
 
}
}

