using Gtk;
using Vte;
/*
* Copyright (c) 2017 Robert San <robertsanseries@gmail.com>
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

namespace BookmarkManager {

    /**
     * [PopoverButtom description]
     * @type {[type]}
     */
    public class Terminal : Vte.Terminal {

    	private GLib.Pid child_pid;
    	private string shell;

        public Terminal () {
        	Object();
        	        	
        	define_color_terminal ();

        	// a newly allocated string with the user's shell, or null
        	this.shell = Vte.get_user_shell();

        	try {
        		// Allocates a new pseudo-terminal.
				this.pty = new Vte.Pty.sync (Vte.PtyFlags.DEFAULT, null);
				command_spawn_sync ();
			} catch (Error e) {
				GLib.message(e.message);
			}		

			// the child's exit status
			exit_status_action ();
        }

        public void define_color_terminal () {

            Gdk.RGBA background_color = Gdk.RGBA ();
            //background_color.parse ("#FFFFFF");
            background_color.parse ("#252E32");// theme dark
            

            Gdk.RGBA foreground_color = Gdk.RGBA ();
            //foreground_color.parse ("#000000");
            foreground_color.parse ("#94a3a5");// theme dark
            
            string palette_setting = "#07A0C7:#dc322f:#cecccc:#dc322f:#268bd2:#ec0048:#2aa198:#94a3a5:#586e75:#cb4b16:#b58900:#dc322f:#268bd2:#d33682:#2aa198:#6c71c4";
            //string palette_setting = "#073642:#dc322f:#859900:#b58900:#268bd2:#ec0048:#2aa198:#94a3a5:#586e75:#cb4b16:#859900:#b58900:#268bd2:#d33682:#2aa198:#6c71c4"; theme dark

            string[] hex_palette = {
            	"#000000", "#FF6C60", "#A8FF60", "#FFFFCC", "#96CBFE", "#FF73FE", "#C6C5FE", "#EEEEEE", 
                "#000000", "#FF6C60", "#A8FF60", "#FFFFB6", "#96CBFE", "#FF73FE", "#C6C5FE", "#EEEEEE"
            };

            string current_string = "";

            int current_color = 0;
            for (var i = 0; i < palette_setting.length; i++) {
                if (palette_setting[i] == ':') {
                    hex_palette[current_color] = current_string;
                    current_string = "";
                    current_color++;
                } else {
                    current_string += palette_setting[i].to_string ();
                }
            }

            Gdk.RGBA[] palette = new Gdk.RGBA[16];      

            for (int i = 0; i < hex_palette.length; i++) {
                Gdk.RGBA new_color = Gdk.RGBA ();
                new_color.parse (hex_palette[i]);

                palette[i] = new_color;
            }

            this.set_colors (foreground_color, background_color, palette);
        }

        /**
         * Starts the specified command under a newly-allocated controlling pseudo-terminal.
         */
        private void command_spawn_sync () {
        	try {
	        	this.spawn_sync(
					Vte.PtyFlags.DEFAULT,
					"~/",
					{ this.shell },
					null,
					SpawnFlags.SEARCH_PATH,
					null,
					out this.child_pid,
					null
				);
			} catch (Error e) {
				GLib.message(e.message);
			}	
        }

        public void run_command(string command)
		{
			try {
	        	this.spawn_sync(
					Vte.PtyFlags.DEFAULT,
					"~/",
					command.split(" "),
					null,
					SpawnFlags.SEARCH_PATH,
					null,
					out this.child_pid,
					null
				);
			} catch (Error e) {
				GLib.message(e.message);
			}
		}

        /**
         * // the child's exit status - This signal is emitted when the terminal detects
		 *  that a child watched using watch_child has exited.
         * @return {[type]} [description]
         */
        private void exit_status_action () {
        	try {
				this.child_exited.connect(() => {
					this.reset(true, true);
					command_spawn_sync ();
				});
			} catch (Error e) {
				GLib.message(e.message);
			}	
        }
    }
}
