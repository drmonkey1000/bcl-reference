package viko.bcl;

import sys.io.File;
import sys.io.FileOutput;

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
	 */
	public function addStdFormRbf(index:Int, char:String, loopCount:Int)
	{
		addStr('At $index ($char) with $loopCount loops');
	}
	
}