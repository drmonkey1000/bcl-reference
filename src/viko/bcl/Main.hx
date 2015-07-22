package viko.bcl;

import sys.io.File;
import viko.bcl.BclLog;

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
	static inline var headerString = "BCL-reference 1.0debug - https://www.vikomprenas.com/public/bcl/index.htm";
	#else
	static inline var headerString = "BCL-reference 1.0 - https://www.vikomprenas.com/public/bcl/index.htm";
	#end
	
	static function main() 
	{
		args = Sys.args();
		flags = new Array<String>();
		params = new Map<String, String>();
		
		if (args.length == 0)
		{
			Sys.println('Syntax error (no args). Use command "help" for help or "info" for information.');
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
				Sys.println(headerString);
				Sys.println('bcl help');
				Sys.println('    Prints this help message.');
				Sys.println('bcl info');
				Sys.println('    Prints some basic information.');
				Sys.println('bcl rbf [file] [-l]');
				Sys.println('    Interprets Restricted Brainf*** from the command line.');
				Sys.println('    Expects entered code to end with a ~.');
				Sys.println('    If a file is given, reads that. -l generates a log file \'rbf.log\'.');
				Sys.println('bcl lbcl [file] [-l]');
				Sys.println('    Interprets Low BCL from the command line.');
				Sys.println('    Expects entered code to end with a ~.');
				Sys.println('    If a file is given, reads that. -l generates a log file \'lbcl.log\'.');
				Sys.println('bcl hbcl [file] [-l]');
				Sys.println('    Interprets High BCL from the command line.');
				Sys.println('    Expects entered code to end with a ~.');
				Sys.println('    If a file is given, reads that. -l generates a log file \'hbcl.log\'.');
			case "info":
				Sys.println(headerString);
				Sys.println('Copyright (C) 2015 Vi Komprenas <viko@vikomprenas.com>');
				Sys.println('Licensed under the MIT license. For details, see:');
				Sys.println('  https://raw.githubusercontent.com/ViKomprenas/bcl-reference/master/LICENSE');
			case "rbf":
				var bcl = new Bcl(flags.indexOf('-l') != -1 ? "rbf.log" : "");
				var code:String = makeCode();
				Sys.stderr().writeString(bcl.rbf(code));
			case "lbcl":
				var bcl = new Bcl(flags.indexOf('-l') != -1 ? "lbcl.log" : "");
				var code:String = makeCode();
				Sys.stderr().writeString(bcl.lbcl(code));
			case "hbcl":
				var bcl = new Bcl(flags.indexOf('-l') != -1 ? "hbcl.log" : "");
				var code:String = makeCode();
				Sys.stderr().writeString(bcl.hbcl(code));
			default:
				Sys.println('Syntax error (bad command). Use command "help" for help or "info" for information.');
		}
	}
	
	static function makeCode():String
	{
		if (params.exists('_1_'))
		{
			var file = File.read(params.get('_1_'), false);
			var g = file.readAll().toString();
			if (g.indexOf('~') != -1)
				g = g.split('~')[0];
			return g;
		}
		else
		{
			var g = Sys.stdin().readUntil('~'.charCodeAt(0));
			Sys.stdin().readLine();
			return g;
		}
	}
	
}