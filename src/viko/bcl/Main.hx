package viko.bcl;

import cpp.Lib;

/**
 * The terminal client to viko.bcl.Bcl.
 * @author Viko <viko@vikomprenas.com>
 */
class Main 
{
	
	static var args:Array<String>;
	static var params:Map<String, String>;
	static var flags:Array<String>;
	
	#if debug
	static inline var headerString = "BCL-reference 0.1debug - https://www.vikomprenas.com/public/bcl/index.htm";
	#else
	static inline var headerString = "BCL-reference 0.1 - https://www.vikomprenas.com/public/bcl/index.htm";
	#end
	
	static function main() 
	{
		args = Sys.args();
		flags = new Array<String>();
		params = new Map<String, String>();
		
		if (args.length == 0)
		{
			Lib.println('Syntax error (no args). Use command "help" for help or "info" for information.');
			return;
		}
		
		// This whole thing is quite complicated and doesn't exactly follow the standard format
		// Eventually I will write a proper library for implementing that in this format and fix it there
		for (argid in 0...args.length)
		{
			var arg = args[argid];
			if (arg.charAt(0) == '-') {
				if (arg.indexOf('=') != -1) {
					params.set(arg.split('=')[0].substr(1), arg.split('=').slice(1).join('=')); // substr 1 to avoid the -
				}
				else
				{
					flags.push(arg);
				}
			} else {
				params.set('_${argid}_', arg);
			}
		}
		
		switch (params.get("_0_")) {
			case "help":
				Lib.println(headerString);
				Lib.println('bcl help');
				Lib.println('    Prints this help message.');
				Lib.println('bcl info');
				Lib.println('    Prints some basic information.');
				Lib.println('bcl i-rbf');
				Lib.println('    Interprets Restricted Brainf*** from the command line.');
				Lib.println('    Expects entered code to end with a ~.');
			case "info":
				Lib.println(headerString);
				Lib.println('Copyright (C) 2015 Vi Komprenas <viko@vikomprenas.com>');
				Lib.println('Licensed under the MIT license. For details, see:');
				Lib.println('  https://raw.githubusercontent.com/ViKomprenas/bcl-reference/master/LICENSE');
			case "i-rbf":
				var bcl = new Bcl();
				bcl.rbf(Sys.stdin().readUntil('~'.charCodeAt(0)));
			default:
				Lib.println('Syntax error (bad command). Use command "help" for help or "info" for information.');
		}
	}
	
}