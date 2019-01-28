namespace BookmarkManager {
public class App:Application {

    ConfigFileReader config_file_reader = new ConfigFileReader ();

    public override void activate () {
        var bookmarks = config_file_reader.get_bookmarks ();
        var desktop_file_manager = new DesktopFileManager ();
        desktop_file_manager.write_to_desktop_file (bookmarks);
    }

    public static int main (string[] args) {
        new App ().run (args);
        return 0;
    }
}
}

