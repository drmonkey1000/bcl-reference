package viko.bcl;

import haxe.Int64;
import haxe.io.Input;

using haxe.Int64;

/**
 * The reference implementation of the BCL programming language.
 * @author Viko <viko@vikomprenas.com>
 */
class Bcl
{
	
	public var tape:Array<Int64> = [0];
	public var ptr:Int = 0;
	public var loops:Array<Int> = []; // A stack showing what loops the code is running right now. Pointers to their [.
	public var ifs:Array<Int> = []; // A stack showing what ifs are being done right now. 1 = skip to ) on | - 2 = do |.
	
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
					Sys.print(a);
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
					Sys.print(a);
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
					log.addStr('Hardcoded $a');
					tape[ptr] = code.charCodeAt(i);
				case '#':
					try
						i = skipNested(code, i, '\n', '')
					catch (s:Dynamic)
					{
						if (s == 'No matching \n after $i (#)')
							break; // Comment at the end of the program
						else
							return s;
					}
				case 'X':
					Sys.exit(cast tape[ptr].mod(256));
				default: // nothing
			}
			
			i++;
		}
		
		return "";
	}
	
	/**
	 * Interpret High BCL.
	 * @param	code	The code to run.
	 * @return	An error string, if any, or "" if none.
	 */
	public function hbcl(code:String):String
	{
		var c:String; // the character being processed
		var i = 0; // the index in the code
		var a:Dynamic; // a various value
		var b:Dynamic; // another various value
		var lastChangesCaret:Int = -1; // whether or not the last command was one of ' " : ;
		while (i < code.length)
		{
			c = code.charAt(i);
			log.addStdFormHbcl(i, c, loops.length, ptr, tape[ptr]);
			lastChangesCaret = -1;
			
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
					Sys.print(a);
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
					log.addStr('Hardcoded $a');
					tape[ptr] = code.charCodeAt(i);
				case '#':
					try
						i = skipNested(code, i, '\n', '')
					catch (s:Dynamic)
					{
						if (s == 'No matching \n after $i (#)')
							break; // Comment at the end of the program
						else
							return s;
					}
				case 'X':
					Sys.exit(cast tape[ptr].mod(256));
				case "'":
					i++; a = "";
					while (i < code.length)
					{
						if (code.charAt(i) == "'")
							break;
						a += code.charAt(i);
						i++;
					}
					b = ptr;
					for (ch in cast (a, String).split(""))
					{
						tapeCheckAlt(b);
						tape[b] = ch.charCodeAt(0);
						b++;
					}
					lastChangesCaret = b;
				case '"':
					i++; a = "";
					while (i < code.length)
					{
						if (code.charAt(i) == '"')
							break;
						a += code.charAt(i);
						i++;
					}
					b = ptr;
					for (ch in cast (a, String).split(""))
					{
						tapeCheckAlt(b);
						tape[b] = ch.charCodeAt(0);
						b++;
					}
					tapeCheckAlt(b + 1);
					tape[b + 1] = 0;
					lastChangesCaret = b + 1;
				case ':':
					a = ptr; b = ptr;
					while (true)
					{
						tapeCheckAlt(a);
						if (tape[a] == 0)
							break;
						ptr = a;
						rbf('.');
						ptr = b;
						a++;
					}
					lastChangesCaret = a;
				case '^':
					i++; a = -1;
					while (true)
					{
						b = code.charAt(i);
						if (b != '0' && b != '1' && b != '2' && b != '3' && b != '4' && b != '5' && b != '6' && b != '7' && b != '8' && b != '9')
							break;
						else
						{
							if (a == -1)
							{
								a = 0;
							}
							a = a * 10 + Std.parseInt(b);
						}
					}
					
					if (a == -1 && lastChangesCaret != -1)
						ptr = lastChangesCaret;
					else
					{
						if (a == -1)
						{
							a = 0;
							i--; // This means there were no digits
						}
						ptr = a;
					}
				case '(':
					log.addStr('Doing a ( between ${tape[ptr]} and ${tape[ptr + 1]}');
					if (tape[ptr] == tape[ptr + 1])
						ifs.push(1);
					else
						i = skipNested(code, i, '|', '(');
				case '|':
					log.addStr('Doing a | with last ifs ${ifs[ifs.length - 1]}');
					if (ifs.pop() == 1)
						i = skipNested(code, i, ')', '(');
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
	 * @param	nests	The character that can start a nesting with this character. If length != 1, does not account for nests.
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
		tapeCheckAlt(ptr);
	}
	
	function tapeCheckAlt(p:Int) 
	{
		if (ptr < 0)
			ptr = 0;
		while (ptr > tape.length - 1)
			tape.push(0);
	}
	
}