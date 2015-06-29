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

	public function new(logfilename:String = "") 
	{
		init(logfilename);
	}
	
	public function init(logfilename:String = ""):Void
	{
		tape = new Array<Int64>();
		tape.push(0);
		ptr = 0;
		loops = new Array<Int>();
		log = new BclLog(logfilename);
	}
	
	/**
	 * Interpret Reparied Brainf***. Call init() to reset the environment.
	 * @param	in	A stream to read the commands from.
	 * @return	An error string, if any, or "" if none.
	 */
	public function rbf(code:String):String
	{
		var c:String; var i = 0; var a:Dynamic;
		while (i < code.length - 1)
		{
			c = code.charAt(i);
			log.addStdFormRbf(i, c, loops.length);
			
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
					a = String.fromCharCode(Int64.toInt(tape[ptr].mod(cast Math.pow(2, 31))));
					Lib.print(a);
					log.addStr('Output $a');
				case ',':
					a = Sys.stdin().readString(1).charCodeAt(0);
					tape[ptr] = Int64.ofInt(a);
					log.addStr('Input ${String.fromCharCode(a)}');
				case '[':
					if (tape[ptr] == 0)
					{
						i = skipNested(code, i, ']', ['[']);
					}
					else
					{
						loops.push(i);
					}
				case ']':
					if (loops.length == 0)
					{
						return 'bad \']\' at $i';
					}
					else
					{
						if (tape[ptr] != 0)
						{
							i = loops[loops.length - 1];
						}
						else
						{
							loops.pop();
						}
					}
				default:
					i++;
					continue;
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
	function skipNested(inside:String, start:Int, until:String, nests:Array<String>):Int
	{
		#if debug
		// Log information about the skip
		log.addStr('-D- Skipping from $start (${inside.charAt(start)}) until next $until, nesting with $nests');
		#end
		
		var nestCount = 0; var c = ""; var i = -1; var thatsit = false;
		for (i in start...inside.length)
		{
			c = inside.charAt(i);
			
			for (c2 in nests) 
			{
				if (c == c2)
				{
					thatsit = true;
					continue;
				}
			}
			
			if (thatsit) // that is, if nests contains c
			{
				nestCount += 1;
			}
			else if (c == until)
			{
				if (nestCount == 0)
				{
					#if debug
					log.addStr('-D- Got to ${start + i + 1} (${inside.charAt(start + i + 1)}) ');
					#end
					return start + i + 1;
				}
				else
					nestCount -= 1;
			}
		}
		
		#if debug
		log.addStr('-D- Got to the end of the string.');
		#end
		
		return i;
	}
	
	function tapeCheck() 
	{
		if (ptr < 0)
			ptr = 0;
		while (ptr > tape.length - 1)
			tape.push(0);
	}
	
}