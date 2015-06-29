package viko.bcl;

import sys.io.File;
import sys.io.FileOutput;
import haxe.Int64;

/**
 * A mechanism to log data about the program's execution.
 * @author Viko <viko@vikomprenas.com>
 */
class BclLog
{
	
	public var data:Array<String>;
	public var file:FileOutput;

	public function new(logfilename:String) 
	{
		data = new Array<String>();
		if (logfilename != null && logfilename != "")
			file = File.write(logfilename, false);
		else
			file = null;
	}
	
	public function close()
	{
		file.close();
	}
	
	public function addStr(x:String):Void
	{
		data.push(x);
		if (file != null)
		{
			file.writeString(x + '\n');
			file.flush();
		}
	}
	
	/**
	 * Add a standard-form string to the log, in the Repaired Brainf*** format.
	 * @param	index		The current index in the string.
	 * @param	char		The character at that point.
	 * @param	loopCount	How many loops there are.
	 * @param	ptr			The pointer to the tape.
	 * @param	cellValue	The value under that pointer.
	 */
	public function addStdFormRbf(index:Int, char:String, loopCount:Int, ptr:Int, cellValue:Int64)
	{
		addStr('At $index ($char) with $loopCount loops. Tape is at $ptr which is $cellValue (${String.fromCharCode(cast cellValue.low)}).');
	}
	
	/**
	 * Add a standard-form string to the log, in the Low BCL format.
	 * @param	index		The current index in the string.
	 * @param	char		The character at that point.
	 * @param	loopCount	How many loops there are.
	 * @param	ptr			The pointer to the tape.
	 * @param	cellValue	The value under that pointer.
	 */
	public function addStdFormLbcl(index:Int, char:String, loopCount:Int, ptr:Int, cellValue:Int64)
	{
		addStr('At $index ($char) with $loopCount loops. Tape is at $ptr which is $cellValue (${String.fromCharCode(cast cellValue.low)}).');
	}
	
}