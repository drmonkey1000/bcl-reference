package viko.bcl;

import cpp.Lib;

/**
 * The terminal client to viko.bcl.Bcl.
 * @author Viko <viko@vikomprenas.com>
 */
class Main 
{
	
	static var args:Array<String>;
	static var command:String;
	static var params:Array<String>;
	
	#if debug
	static inline var headerString = "BCL-reference 0.1debug - https://www.vikomprenas.com/public/bcl/index.htm";
	#else
	static inline var headerString = "BCL-reference 0.1 - https://www.vikomprenas.com/public/bcl/index.htm";
	#end
	
	static function main() 
	{
		args = Sys.args();
		command = "";
		params = new Array<String>();
		Lib.println(headerString);
		
		if (args.length == 0)
		{
			Lib.println('Syntax error. Use command ":help" for help or ":info" for information.');
			return;
		}
		
		for (arg in args)
		{
			if (arg.charAt(0) == ":")
			{
				// Commands start with :. This means that two lines `bcl -hi :one` and `bcl -zone :two` can be combined as `bcl -hi :one -zone :two`.
				// Note to self: this paradigm could be generalized.
				Lib.println("");
				command = arg;
				
				switch (command) 
				{
					case ":help":
						Lib.println('Commands can be chained together - the : prefix tells BCL where to stop.');
						Lib.println('The commands are:');
						Lib.println('   :help     View this help information.');
						Lib.println('   :info     List some information about the language.');
						Lib.println('   :copy     Display copyright information.');
					case ":info":
						Lib.println('This is the reference implementation of BCL, the Brainf*** Computing Language.');
					case ":copy":
						Lib.println('This program is licensed under the MIT license. For more details, see:');
						Lib.println('   https://raw.githubusercontent.com/ViKomprenas/bcl-reference/develop/LICENSE');
					default:
						Lib.println('Syntax error. Use command ":help" for help or ":info" for information.');
				}
			}
		}
	}
	
}