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
	static var command:String;
	
	#if debug
	static inline var headerString = "BCL-reference 0.1debug - https://www.vikomprenas.com/public/bcl/index.htm";
	#else
	static inline var headerString = "BCL-reference 0.1 - https://www.vikomprenas.com/public/bcl/index.htm";
	#end
	
	static function main() 
	{
		args = Sys.args();
		command = "";
		flags = new Array<String>();
		params = new Map<String, String>();
		Lib.println(headerString);
		
		if (args.length == 0)
		{
			Lib.println('Syntax error. Use command "help" for help or "info" for information.');
			return;
		}
		
		// This whole thing is quite complicated and doesn't exactly follow the standard format
		// Eventually I will write a proper library for implementing that in this format and fix it there
		for (arg in args)
		{
			if (arg.charAt(0) == '-') {
				if (arg.indexOf('=') != -1) {
					params.set(arg.split('=')[0].substr(1), arg.split('=').slice(1).join('=')); // substr 1 to avoid the -
				}
				else
				{
					flags.push(arg);
				}
			} else {
				if (command != "")
				{
					Lib.println('Syntax error. Use command "help" for help or "info" for information.');
					return;
				}
				else
				{
					command = arg;
				}
			}
		}
		
		// TODO: add code
	}
	
}