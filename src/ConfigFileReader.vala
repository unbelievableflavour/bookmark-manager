namespace BookmarkManager {
public class ConfigFileReader : Object {

    public Bookmark[] get_bookmarks () {
        Bookmark[] bookmarks = {};

        var file = get_ssh_config_file ();

        try {
            var lines = new DataInputStream (file.read ());
            string line;

            while ((line = lines.read_line (null)) != null) {

                var splitted_line = line.split (" ");
                string variable_on_line = get_filtered_variable (splitted_line);
                string value_on_line = get_filtered_value (splitted_line);

                if (variable_on_line == null) {continue;}

                if (in_array (variable_on_line, { "host", "Host" })) {
                    bookmarks += new Bookmark ();
                    bookmarks[bookmarks.length - 1].set_name (value_on_line);
                    continue;
                }
                if (bookmarks.length == 0) {
                    continue;
                }
                if (in_array (variable_on_line, { "#nickname", "#Nickname" })) {
                    bookmarks[bookmarks.length - 1].set_nickname (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "hostName", "HostName" })) {
                    bookmarks[bookmarks.length - 1].set_ip (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "port", "Port" })) {
                    bookmarks[bookmarks.length - 1].set_port (int.parse (value_on_line));
                    continue;
                }
                if (in_array (variable_on_line, { "user", "User" })) {
                    bookmarks[bookmarks.length - 1].set_user (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "forward_agent", "ForwardAgent" })) {
                    bookmarks[bookmarks.length - 1].set_forward_agent (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "proxy_command", "ProxyCommand" })) {
                    bookmarks[bookmarks.length - 1].set_proxy_command (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "server_alive_interval", "ServerAliveInterval" })) {
                    bookmarks[bookmarks.length - 1].set_server_alive_interval (int.parse (value_on_line));
                    continue;
                }
                if (in_array (variable_on_line, { "log_level", "LogLevel" })) {
                    bookmarks[bookmarks.length - 1].set_log_level (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "strict_host_key_checking", "StrictHostKeyChecking" })) {
                    bookmarks[bookmarks.length - 1].set_strict_host_key_checking (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "user_known_hosts_file", "UserKnownHostsFile" })) {
                    bookmarks[bookmarks.length - 1].set_user_known_hosts_file (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "visual_host_key", "VisualHostKey" })) {
                    bookmarks[bookmarks.length - 1].set_visual_host_key (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "compression", "Compression" })) {
                    bookmarks[bookmarks.length - 1].set_compression (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "local_forward", "LocalForward" })) {
                    bookmarks[bookmarks.length - 1].set_local_forward (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "remote_forward", "RemoteForward" })) {
                    bookmarks[bookmarks.length - 1].set_remote_forward (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "dynamic_forward", "DynamicForward" })) {
                    bookmarks[bookmarks.length - 1].set_dynamic_forward (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "forward_x11", "ForwardX11" })) {
                    bookmarks[bookmarks.length - 1].set_forward_x11 (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "identity_file", "IdentityFile" })) {
                    bookmarks[bookmarks.length - 1].set_identity_file (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "identities_only", "IdentitiesOnly" })) {
                    bookmarks[bookmarks.length - 1].set_identities_only (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "control_master", "ControlMaster" })) {
                    bookmarks[bookmarks.length - 1].set_control_master (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "control_path", "ControlPath" })) {
                    bookmarks[bookmarks.length - 1].set_control_path (value_on_line);
                    continue;
                }
                if (in_array (variable_on_line, { "control_persist", "ControlPersist" })) {
                    bookmarks[bookmarks.length - 1].set_control_persist (value_on_line);
                    continue;
                }
            }

           return bookmarks;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    bool in_array ( string needle, string[] haystack ) {
        if (needle in haystack) {
            return true;
        }
        return false;
    }


    public string[] get_other_settings () {
        string[] settings = new string[0];

        var file = get_ssh_config_file ();

        try {
            var lines = new DataInputStream (file.read ());
            string line;

            while ((line = lines.read_line (null)) != null) {

                var splitted_line = line.split (" ");
                string variable_on_line = get_filtered_variable (splitted_line);

                if (line == "" || variable_on_line == null) {
                    continue;
                }

                if (in_array (variable_on_line, { "host", "Host" })) {
                    break;
                }

                settings += line;
            }

           return settings;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public string get_filtered_variable (string[] splitted_line) {
        foreach (string part in splitted_line) {
            if (part == "") {
                continue;
            }
            return part;
        }
        return splitted_line[0];
    }

    public string get_filtered_value (string[] splitted_line) {
        var elements_count = 0;
        string filtered_value = "";
        foreach (string part in splitted_line) {
            if (part == "") {
                continue;
            }

            if (elements_count == 0 ) {
                elements_count++;
                continue;
            }

            if (elements_count == 1 ) {
                filtered_value += part;
                elements_count++;
                continue;
            }

            filtered_value += " " + part;
        }
        return filtered_value;
    }

    private File get_ssh_config_file () {
        string path = Environment.get_home_dir ();

        var ssh_folder = File.new_for_path (path + "/.ssh/");
        if (!ssh_folder.query_exists ()) {
            try {
                ssh_folder.make_directory ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        var file = File.new_for_path (path + "/.ssh/config");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                get_ssh_config_file ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        var backup_file = File.new_for_path (path + "/.ssh/config_backup");
        if (!backup_file.query_exists ()) {
            try {
                file.copy (backup_file, 0, null);
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        return file;
    }

    public void write_to_file (Bookmark[] bookmarks) {
        var file = get_ssh_config_file ();

        try {
            if (file.query_exists () == true) {
                var other_settings = get_other_settings ();
                string bookmarks_raw = convert_bookmarks_to_string (bookmarks);
                var other_settings_raw = convert_other_settings_to_string (other_settings);

                file.delete (null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);

                dos.put_string (other_settings_raw + bookmarks_raw, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private string convert_other_settings_to_string (string[] settings) {
        string raw_settings_string = "";

        foreach (string setting in settings) {
            string raw_setting = setting + "\n";
            raw_settings_string += raw_setting;
        }

        raw_settings_string += "\n";
        return raw_settings_string;
    }

    private string convert_bookmarks_to_string (Bookmark[] bookmarks) {
        string raw_bookmarks_string = "";

        foreach (Bookmark bookmark in bookmarks) {
            string raw_bookmark = convert_bookmark_to_string (bookmark);
            raw_bookmarks_string += raw_bookmark;
        }

        return raw_bookmarks_string;
    }

    private string convert_bookmark_to_string (Bookmark bookmark) {
        string raw_bookmark = "Host " + bookmark.get_name ();

        if (bookmark.get_nickname () != null && bookmark.get_nickname () != "") {
            raw_bookmark += "\n    #nickname " + bookmark.get_nickname ();
        }

        if (bookmark.get_ip () != null) {
            raw_bookmark += "\n    HostName " + bookmark.get_ip ().to_string ();
        }

        if (bookmark.get_port () != 0) {
            raw_bookmark += "\n    Port " + bookmark.get_port ().to_string ();
        }

        if (bookmark.get_user () != null && bookmark.get_user () != "") {
            raw_bookmark += "\n    User " + bookmark.get_user ();
        }

        if (bookmark.get_forward_agent () != null) {
            raw_bookmark += "\n    ForwardAgent " + bookmark.get_forward_agent ();
        }

        if (bookmark.get_proxy_command () != null && bookmark.get_proxy_command () != "") {
            raw_bookmark += "\n    ProxyCommand " + bookmark.get_proxy_command ();
        }

        if (bookmark.get_server_alive_interval () != 0) {
            raw_bookmark += "\n    ServerAliveInterval " + bookmark.get_server_alive_interval ().to_string ();
        }

        if (bookmark.get_log_level () != null && bookmark.get_log_level () != "") {
            raw_bookmark += "\n    LogLevel " + bookmark.get_log_level ();
        }

        if (bookmark.get_strict_host_key_checking () != null && bookmark.get_strict_host_key_checking () != "") {
            raw_bookmark += "\n    StrictHostKeyChecking " + bookmark.get_strict_host_key_checking ();
        }

        if (bookmark.get_user_known_hosts_file () != null && bookmark.get_user_known_hosts_file () != "") {
            raw_bookmark += "\n    UserKnownHostsFile " + bookmark.get_user_known_hosts_file ();
        }

        if (bookmark.get_visual_host_key () != null && bookmark.get_visual_host_key () != "") {
            raw_bookmark += "\n    VisualHostKey " + bookmark.get_visual_host_key ();
        }

        if (bookmark.get_compression () != null && bookmark.get_compression () != "") {
            raw_bookmark += "\n    Compression " + bookmark.get_compression ();
        }

        if (bookmark.get_local_forward () != null && bookmark.get_local_forward () != "") {
            raw_bookmark += "\n    LocalForward " + bookmark.get_local_forward ();
        }

        if (bookmark.get_remote_forward () != null && bookmark.get_remote_forward () != "") {
            raw_bookmark += "\n    RemoteForward " + bookmark.get_remote_forward ();
        }

        if (bookmark.get_dynamic_forward () != null && bookmark.get_dynamic_forward () != "") {
            raw_bookmark += "\n    DynamicForward " + bookmark.get_dynamic_forward ();
        }

        if (bookmark.get_forward_x11 () != null && bookmark.get_forward_x11 () != "") {
            raw_bookmark += "\n    ForwardX11 " + bookmark.get_forward_x11 ();
        }

        if (bookmark.get_identity_file () != null && bookmark.get_identity_file () != "") {
            raw_bookmark += "\n    IdentityFile " + bookmark.get_identity_file ();
        }

        if (bookmark.get_identities_only () != null && bookmark.get_identities_only () != "") {
            raw_bookmark += "\n    IdentitiesOnly " + bookmark.get_identities_only ();
        }

        if (bookmark.get_control_master () != null && bookmark.get_control_master () != "") {
            raw_bookmark += "\n    ControlMaster " + bookmark.get_control_master ();
        }

        if (bookmark.get_control_path () != null && bookmark.get_control_path () != "") {
            raw_bookmark += "\n    ControlPath " + bookmark.get_control_path ();
        }

        if (bookmark.get_control_persist () != null && bookmark.get_control_persist () != "") {
            raw_bookmark += "\n    ControlPersist " + bookmark.get_control_persist ();
        }

        raw_bookmark += "\n\n";
        return raw_bookmark;
    }
}
}
