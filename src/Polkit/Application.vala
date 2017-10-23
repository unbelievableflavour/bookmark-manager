public static int main (string[] args) {

  string homeDir = Environment.get_home_dir ();

  // Create the variables for the process execution
  string[] spawnArguments = {"pkexec", "env", "HOME=" + homeDir, "com.github.bartzaalberg.bookmark-manager-quicklist"};
  string[] spawnEnvironment = Environ.get ();
  string spawnStdOut;
  string spawnStdError;
  int spawnExitStatus;

  try {
    // Spawn the process synchronizedly
    // We do it synchronizedly because since we are just launching another process and such is the whole
    // purpose of this program, we don't want to exit this, the caller, since that will cause our spawned process to become a zombie.
    
    Process.spawn_sync ("/", spawnArguments, spawnEnvironment, SpawnFlags.SEARCH_PATH, null, out spawnStdOut, out spawnStdError, out spawnExitStatus);

    // Print the output if any
    stdout.printf ("Output: %s\n", spawnStdOut);
    // Print the error if any
    stderr.printf ("There was an error in the spawned process: %s\n", spawnStdError);
    // Print the exit status
    stderr.printf ("Exit status was: %d\n", spawnExitStatus);
  } catch (SpawnError spawnCaughtError) {
    stderr.printf ("There was an error spawining the process. Details: %s", spawnCaughtError.message);
  }

  return 0;
}
