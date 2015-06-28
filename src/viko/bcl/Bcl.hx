package viko.bcl;

import cpp.Lib;
import haxe.Int64;
import haxe.io.Input;

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
	 */
	public function rbf(code:String):Void
	{
		trace(code);
	}
	
}