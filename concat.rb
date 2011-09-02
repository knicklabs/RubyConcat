#!/usr/bin/env ruby

# Ruby Concat
#
# This is a command line build script intended for JavaScript projects but useful for other types of files
# as well. It's pretty primitive but it gets the job done. Check the readme for basic usage instructions.
#
# Written by Nickolas Kenyeres on September 2, 2011
# Released under the MIT License.
#
# Copyright 2011 Nickolas Kenyeres
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
# THE SOFTWARE.

if ARGV.empty? or ARGV.length != 3
  puts "usage: ruby concat.rb manifest.txt src dest.js"
  exit
end

@exclude = ["^\\."]
@manifest = ARGV[0]
@src = ARGV[1]
@dest = ARGV[2]

# Open the manifest file. This file contains a list of files that need to be concatenated 
# first and in order.
begin
  f = File.open @manifest
rescue => e
  puts e.message
  exit
end

# Read the list of files to concatenate from the manifest.
@file_names = []
f.each_line { |line| @file_names.push line }
f.close

# Appends file contents to a file unless the file is to be excluded.
def appendFile(src, dest)
  Dir.foreach(src) do |file|
    # Do not add file if it was in the exclusion list.
    next if exclude? file
    
    file = File.join(src, file)
    
    # Do not add file if it was in the manifest.
    next if in_manifest? file
    
    if File.directory? file
      appendFile(file, dest) # Recurse over directories.
    else
      # Open the file and copy its contents to the destination.
      begin
        f = File.open(file.strip! || file)
        f.each_line { |line| File.open(dest, 'a') { |f| f.write(line) } }
        f.close
      rescue => e
        puts "FAILED!"
        puts e.message
        exit
      end
    end
  end
end

def in_manifest? file
  file_found = false
  @file_names.each do |file_name|
    file_name = file_name.strip! || file_name
    if file_name == file
      file_found = true
    end
  end
  file_found
end

def exclude? file
  @exclude.each do |s|
    if file.match(/#{s}/i)
      return true
    end
  end
  false
end

# Before we overwrite the build file, make sure each file in the manifest can be opened.
puts "Validating manifest.txt..."
@file_names.each do |file_name|
  begin
    File.open(file_name.strip! || file_name) # Trim whitespace from the file name.
  rescue => e
    puts "FAILED!\n"
    puts e.message
    exit
  end
end
puts "PASSED!\n"

# Create an empty file to write file contents to.
puts "Creating build file..."
begin
  File.open(@dest, 'w') { |f| f.write("") }
rescue => e
  puts "FAILED!\n"
  puts e.message
  exit
end
puts "PASSED!\n"

# Open each file listed in the manifest and copy its contents to the build file.
puts "Adding files from manifest to build..."
@file_names.each do |file_name|
  begin
    f = File.open(file_name.strip! || file_name)
    f.each_line { |line| File.open(@dest, 'a') { |f| f.write(line) } }
    f.close
  rescue => e
    puts "FAILED\n"
    puts e.message
    exit
  end
end
puts "PASSED!\n"

# Open each file in the source folder and copy its contents to the build file 
# unless the file is in the exclusion list or previously listed in the manifest.
puts "Adding files from src folder to build..."
appendFile @src, @dest
puts "PASSED!\n"

puts "ALL DONE\n"

