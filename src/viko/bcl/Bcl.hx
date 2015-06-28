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

	public function new() 
	{
		init();
	}
	
	public function init()
	{
		tape = new Array<Int64>();
		tape.push(0);
		ptr = 0;
		loops = new Array<Int>();
	}
	
	/**
	 * Interpret Reparied Brainf***. Call init() to reset the environment.
	 * @param	in	A stream to read the commands from.
	 * @return	An error string, if any, or "" if none.
	 */
	public function rbf(code:String):String
	{
		var c:String; var i = 0;
		while (i < code.length - 1)
		{
			c = code.charAt(i);
			
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
					Lib.print(String.fromCharCode(Int64.toInt(tape[ptr].mod(cast Math.pow(2, 31)))));
				case ',':
					tape[ptr] = Int64.ofInt(Sys.stdin().readString(1).charCodeAt(0));
				case '[':
					loops.push(i);
					if (tape[ptr] == 0)
						i = skipNested(code, i, ']', ['[']);
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
		var nestCount = 0; var c = ""; var i = -1;
		for (i in 0...inside.length - start)
		{
			c = inside.charAt(start + i);
			
			if (nests.filter(function(s:String) { return s == c; } ).length != 0) // that is, if nests contains c
			{
				nestCount += 1;
			}
			else if (c == until)
			{
				if (nestCount == 0)
					return start + i + 1;
				else
					nestCount -= 1;
			}
		}
		
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