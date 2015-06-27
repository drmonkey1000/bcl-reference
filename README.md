# BCL-reference
This is the reference implementation of the BCL programming language. The implementation is currently incomplete. The specification, version 1.0, is available at http://vikomprenas.com/public/bcl/spec-1_0.md .

## Command line syntax
BCL command-line syntax is fairly simple. Set flags and parameters and then signal a command.
For example, these arguments set flag `f` and parameter `example` (to `1`) and then runs `about`:
```
f example=1 :about
```

To get a list of supported commands and syntax, use the command `help`.

## Library integration
BCL-reference will be able to integrate into any other software written in Haxe.
Coming soon!

## Implemented features
No code at all yet!

## Compiling from source
This project requires Haxe 3.2.0 and no other libraries. The project is kept in FlashDevelop format, so you may need that, or you can try to work it out yourself.

## Contributing
At this time, BCL-reference is closed to contributions.