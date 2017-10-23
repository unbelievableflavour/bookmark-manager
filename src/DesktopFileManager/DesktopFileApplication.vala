namespace BookmarkManager {
public class App:Application{

    ConfigFileReader configFileReader = new ConfigFileReader();

    public override void activate() {
        var bookmarks = configFileReader.getBookmarks();
        var desktopFileManager = new DesktopFileManager();
        desktopFileManager.writeToDesktopFile(bookmarks);
    }

    public static int main(string[] args) {
        new App().run(args);
        return 0;
    }
}
}

