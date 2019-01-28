namespace BookmarkManager {
    void main (string[] args) {
        Test.init (ref args);

        Test.add_func ("/if_parameters_can_be_set", () => {

            string name = "strawberry";
            string ip = "127.0.0.1";
            string user = "nutty";
            int port = 8080;
            string forwardAgent = "yes";
            string proxyCommand = "ssh vivek@Jumphost nc FooServer 22";

            Bookmark bookmark = new Bookmark ();
            bookmark.set_name (name);
            bookmark.set_ip (ip);
            bookmark.set_user (user);
            bookmark.set_port (port);
            bookmark.set_forward_agent (forwardAgent);
            bookmark.set_proxy_command (proxyCommand);

            assert (bookmark.get_name () == name);
            assert (bookmark.get_ip () == ip);
            assert (bookmark.get_user () == user);
            assert (bookmark.get_port () == port);
            assert (bookmark.get_forward_agent () == forwardAgent);
            assert (bookmark.get_proxy_command () == proxyCommand);
        });

        Test.run ();
    }
}
