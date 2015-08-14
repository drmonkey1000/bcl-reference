# BCL-reference
![master](https://travis-ci.org/ViKomprenas/bcl-reference.svg?branch=master)

This is the reference implementation of the BCL programming language. The implementation is currently incomplete. The specification, version 1.0, is available at http://www.vikomprenas.com/bcl/spec-1_0.md .

## Command line syntax
```
bcl help
bcl info

# These read from standard input until ~
bcl rbf
bcl lbcl
bcl hbcl

# These read from a file (if ~, cut off there, else go to EOF)
bcl rbf somecode.rbf
bcl lbcl somecode.lbcl
bcl hbcl somecode.hbcl
```

To get a list of supported commands and syntax, use the command `help`.

## Library integration
BCL-reference is able to integrate into any other software written in Haxe. Example:
```haxe
import viko.bcl.Bcl;

// ...

var bcl:Bcl = new Bcl(); // create a new environment
bcl.rbf("+[]"); // run some RBF code
bcl.init(); // reset the environment
bcl.lbcl("=$[]"); // run some Low BCL code
bcl.lbcl("[]"); // run more Low BCL code (note: because there is no init() we keep the environment!)
bcl.rbf("[-]"); // run some RBF code in the same environment
bcl.lbcl("0>+[]"); // run more Low BCL code, they can share the environment
```

## Implemented features
All Brainf\*\*\* commands are implemented. All Low BCL commands are implemented. However, these should be considered as in beta.

## Compiling from source
This project requires Haxe 3.2.0 and no other libraries. The project is kept in FlashDevelop format, so you may need that, or you can try to work it out yourself.

## Contributing
At this time, BCL-reference is closed to contributions.

Hello I am steel all credit
