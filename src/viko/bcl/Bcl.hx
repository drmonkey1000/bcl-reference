package viko.bcl;

import cpp.Lib;
import haxe.Int64;
import haxe.io.Input;

using haxe.Int64;

/**
 * The reference implementation of the BCL programming language.
 * @author Viko <viko@vikomprenas.com>
 */
class Bcl
{
	
	public var tape:Array<Int64>;
	public var ptr:Int;
	public var loops:Array<Int>; // A stack showing what loops the code is running right now. Pointers to their [.
	
	public var log:BclLog;
	
	/**
	 * Create a new BCL interpreter.
	 * @param	logfilename	The file name of the log. Leave blank for no log file (log is still kept in memory).
	 */
	public function new(logfilename:String = "") 
	{
		init(logfilename);
	}
	
	/**
	 * Reset the environment.
	 * @param	logfilename	The file name of the log. Leave blank for no log file (log is still kept in memory).
	 */
	public function init(logfilename:String = ""):Void
	{
		tape = new Array<Int64>();
		tape.push(0);
		ptr = 0;
		loops = new Array<Int>();
		log = new BclLog(logfilename);
	}
	
	/**
	 * Interpret Reparied Brainf***.
	 * @param	code	The code to run.
	 * @return	An error string, if any, or "" if none.
	 */
	public function rbf(code:String):String
	{
		var c:String; var i = 0; var a:Dynamic;
		while (i < code.length)
		{
			c = code.charAt(i);
			log.addStdFormRbf(i, c, loops.length, ptr, tape[ptr]);
			
			switch (c) {
				case '>':
					ptr += 1;
					tapeCheck();
				case '<':
					ptr -= 1;
				case '+':
					tape[ptr] += 1;
				case '-':
					tape[ptr] -= 1;
				case '.':
					a = String.fromCharCode(tape[ptr].low);
					Lib.print(a);
					log.addStr('Output $a');
				case ',':
					a = Sys.stdin().readString(1).charCodeAt(0);
					tape[ptr] = Int64.ofInt(a);
					log.addStr('Input ${String.fromCharCode(a)}');
				case '[':
					if (tape[ptr] == 0)
					{
						try
						{
							i = skipNested(code, i, ']', '[');
							log.addStr('Skipped a loop to $i');
						}
						catch (s:String)
						{
							return s;
						}
					}
					else
						loops.push(i);
				case ']':
					if (loops.length == 0)
						return 'No \'[\' for the \']\' at $i';
					else
					{
						if (tape[ptr] != 0)
						{
							log.addStr('Skipping backward from a \']\' at $i');
							i = loops.pop();
							loops.push(i);
						}
						else
						{
							log.addStr('Tape is 0, so ending the loop on the \']\'');
							loops.pop();
						}
					}
				default: // nothing
			}
			
			i++;
		}
		
		return "";
	}
	
	/**
	 * Interpret Low BCL.
	 * @param	code	The code to run.
	 * @return	An error string, if any, or "" if none.
	 */
	public function lbcl(code:String):String
	{
		var c:String; var i = 0; var a:Dynamic;
		while (i < code.length)
		{
			c = code.charAt(i);
			log.addStdFormLbcl(i, c, loops.length, ptr, tape[ptr]);
			
			switch (c) {
				case '>':
					ptr += 1;
					tapeCheck();
				case '<':
					ptr -= 1;
				case '+':
					tape[ptr] += 1;
				case '-':
					tape[ptr] -= 1;
				case '.':
					a = String.fromCharCode(tape[ptr].low);
					Lib.print(a);
					log.addStr('Output $a');
				case ',':
					a = Sys.stdin().readString(1).charCodeAt(0);
					tape[ptr] = Int64.ofInt(a);
					log.addStr('Input ${String.fromCharCode(a)}');
				case '[':
					if (tape[ptr] == 0)
					{
						try
						{
							i = skipNested(code, i, ']', '[');
							log.addStr('Skipped a loop to $i');
						}
						catch (s:String)
						{
							return s;
						}
					}
					else
						loops.push(i);
				case ']':
					if (loops.length == 0)
						return 'No \'[\' for the \']\' at $i';
					else
					{
						if (tape[ptr] != 0)
						{
							log.addStr('Skipping backward from a \']\' at $i');
							i = loops.pop();
							loops.push(i);
						}
						else
						{
							log.addStr('Tape is 0, so ending the loop on the \']\'');
							loops.pop();
						}
					}
				case '0':
					ptr = 0;
				case 'n':
					tape[ptr] = 0;
				case '=':
					i++;
					a = code.charAt(i);
					log.addStr("Hardcoded $a");
					tape[ptr] = a.charCodeAt(0);
				case '#':
					i = skipNested(code, i, '#', '#');
				case 'X':
					Sys.exit(cast tape[ptr].mod(256));
				default: // nothing
			}
			
			i++;
		}
		
		return "";
	}

	
	/**
	 * Skips forward until meeting a certain character, accounting for nests.
	 * @param	inside	The string to use.
	 * @param	start	The index in inside to start at.
	 * @param	until	The character to stop skipping at.
	 * @param	nests	All the characters that can start a nesting with this character.
	 * @return	The index in inside after the last character of this.
	 */
	public function skipNested(inside:String, start:Int, until:String, nests:String):Int
	{
		#if debug
		// Log information about the skip
		log.addStr('-D- Skipping from $start (${inside.charAt(start)}) until next $until, nesting with $nests');
		#end
		
		var nestCount = 0; var c = ""; var i = -1;
		for (i in start + 1...inside.length)
		{
			c = inside.charAt(i);
			
			if (c == nests)
			{
				nestCount += 1;
			}
			else if (c == until)
			{
				if (nestCount == 0)
				{
					#if debug
					log.addStr('-D- Got to ${i + 1} (${inside.charAt(i + 1)})');
					#end
					return i;
				}
				else
				{
					nestCount -= 1;
				}
			}
		}
		
		#if debug
		log.addStr('-D- Got to the end of the string, now throwing an error');
		#end
		
		throw 'No matching $until after $start (${inside.charAt(start)})';
	}
	
	function tapeCheck() 
	{
		if (ptr < 0)
			ptr = 0;
		while (ptr > tape.length - 1)
			tape.push(0);
	}
	
}