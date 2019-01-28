namespace BookmarkManager {
public class Bookmark : Object {

    private string nickname;

    private string name;
    private string ip;
    private string user;
    private int port;
    private string forward_agent;
    private string proxy_command;

    private int server_alive_interval;
    private string log_level;
    private string strict_host_key_checking;
    private string user_known_hosts_file;
    private string visual_host_key;
    private string compression;

    private string local_forward;
    private string remote_forward;
    private string dynamic_forward;
    private string forward_x11;

    private string identity_file;
    private string identities_only;

    private string control_master;
    private string control_path;
    private string control_persist;

    public string get_nickname () {
        return this.nickname;
    }

    public void set_nickname (string nickname) {
        this.nickname = nickname;
    }

    public string get_name () {
        return this.name;
    }

    public void set_name (string name) {
        this.name = name;
    }

    public string get_ip () {
        return this.ip;
    }

    public void set_ip (string ip) {
        this.ip = ip;
    }

    public string get_user () {
        return this.user;
    }

    public void set_user (string user) {
        this.user = user;
    }

    public int get_port () {
        return this.port;
    }

    public void set_port (int port) {
        this.port = port;
    }

    public string get_forward_agent () {
        return this.forward_agent;
    }

    public void set_forward_agent (string forward_agent) {
        this.forward_agent = forward_agent;
    }

    public string get_proxy_command () {
        return this.proxy_command;
    }

    public void set_proxy_command (string proxy_command) {
        this.proxy_command = proxy_command;
    }

    public int get_server_alive_interval () {
        return this.server_alive_interval;
    }

    public void set_server_alive_interval (int server_alive_interval) {
        this.server_alive_interval = server_alive_interval;
    }

    public string get_log_level () {
        return this.log_level;
    }

    public void set_log_level (string log_level) {
        this.log_level = log_level;
    }

    public string get_strict_host_key_checking () {
        return this.strict_host_key_checking;
    }

    public void set_strict_host_key_checking (string strict_host_key_checking) {
        this.strict_host_key_checking = strict_host_key_checking;
    }

    public string get_user_known_hosts_file () {
        return this.user_known_hosts_file;
    }

    public void set_user_known_hosts_file (string user_known_hosts_file) {
        this.user_known_hosts_file = user_known_hosts_file;
    }

    public string get_visual_host_key () {
        return this.visual_host_key;
    }

    public void set_visual_host_key (string visual_host_key) {
        this.visual_host_key = visual_host_key;
    }

    public string get_compression () {
        return this.compression;
    }

    public void set_compression (string compression) {
        this.compression = compression;
    }

    public string get_local_forward () {
        return this.local_forward;
    }

    public void set_local_forward (string local_forward) {
        this.local_forward = local_forward;
    }

    public string get_remote_forward () {
        return this.remote_forward;
    }

    public void set_remote_forward (string remote_forward) {
        this.remote_forward = remote_forward;
    }

    public string get_dynamic_forward () {
        return this.dynamic_forward;
    }

    public void set_dynamic_forward (string dynamic_forward) {
        this.dynamic_forward = dynamic_forward;
    }

    public string get_forward_x11 () {
        return this.forward_x11;
    }

    public void set_forward_x11 (string forward_x11) {
        this.forward_x11 = forward_x11;
    }

    public string get_identity_file () {
        return this.identity_file;
    }

    public void set_identity_file (string identity_file) {
        this.identity_file = identity_file;
    }

    public string get_identities_only () {
        return this.identities_only;
    }

    public void set_identities_only (string identities_only) {
        this.identities_only = identities_only;
    }

    public string get_control_master () {
        return this.control_master;
    }

    public void set_control_master (string control_master) {
        this.control_master = control_master;
    }

    public string get_control_path () {
        return this.control_path;
    }

    public void set_control_path (string control_path) {
        this.control_path = control_path;
    }

    public string get_control_persist () {
        return this.control_persist;
    }

    public void set_control_persist (string control_persist) {
        this.control_persist = control_persist;
    }
}
}
