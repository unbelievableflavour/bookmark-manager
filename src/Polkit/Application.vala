public static int main (string[] args) {

    string home_dir = Environment.get_home_dir ();

    string[] spawn_arguments = {
        "pkexec",
        "env",
        "HOME=" + home_dir,
        "com.github.bartzaalberg.bookmark-manager-quicklist"
    };
    string[] spawn_environments = Environ.get ();
    string spawn_std_out;
    string spawn_std_error;
    int spawn_exit_status;

    try {
    Process.spawn_sync (
        "/", spawn_arguments, spawn_environments, SpawnFlags.SEARCH_PATH, null,
         out spawn_std_out, out spawn_std_error, out spawn_exit_status
     );

    stdout.printf ("Output: %s\n", spawn_std_out);
    stderr.printf ("There was an error in the spawned process: %s\n", spawn_std_error);
    stderr.printf ("Exit status was: %d\n", spawn_exit_status);
    } catch (SpawnError spawnCaughtError) {
    stderr.printf ("There was an error spawining the process. Details: %s", spawnCaughtError.message);
    }

    return 0;
}
