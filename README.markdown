# Ruby Concat

Ruby Concat is a command line build script useful for building javascript projects. It will work with other 
file types; just don't mix and match!

In a nutshell, this script concatenates a bunch files into a single file. No more, no less.


*There are some things you should know about this script before using it*

1. Required scripts can be included in a manifest file. The scripts listed in the manifest file 
will appear at the top of the output in the order they were listed.

2. All other scripts should be included in a source directory. You may have sub-directories inside
the source directory. The scripts in these directories will appear at the bottom of the output.

3. Scripts will only be included once so you may include scripts from the source directory in your 
manifest.

4. You must specify the location of the manifest, source directory and output file. Use relative 
paths to the location of concat.rb.

5. The path to your output file must exist before you run this script!!!

## The Manifest

The manifest file should be a plain text file. List one script per line. Use relative paths. The 
manifest must be included but can be blank. Here's an example of how the file should be formatted:

`libs/jquery-1.6.2.js
libs/backbone.js
src/startup.js`

## Typical Project Directory Structure

Here's an example of a typical directory structure for a javascript project:

manifest.txt
src/
src/controllers
src/models
src/views
libs/
build/

## Basic Usage

ruby concat.rb <manifest> <source> <destination>
	
Example: ruby concat.rb manifest.txt src build/output.js

## Testing

This script comes packaged with two basic tests. Run them and confirm that the output in the build folder is as 
expected.

ruby concat.rb test/manifest.txt test/src test/build/test_results.js
ruby concat.rb test2/manifest.txt test2/src test2/build/test_results.js

## Copyright and License

# Copyright 2011 Nickolas Kenyeres
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
THE SOFTWARE.