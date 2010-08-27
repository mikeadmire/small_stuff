#!/usr/bin/ruby -w
# Author: Mike Admire
# Synopsis: A command line tool that accepts a filename of a file that has URI encoded
#   text in it and a second filename that will be created by this tool to have the
#   contents of the first file written to it with the URI encoding replaced with plain
#   text.
#   Supports an external translation file to provide a method of replacing characters
#   within the file. This provides a way to do custom translations for unicode
#   characters or characters that don't translate directly to plain text.
# Usage:  uri_to_text.rb filename_with_uri filename_with_plain_text
#
require 'uri'

class App

  def initialize
    @translation_file = 'uri_to_text_translations.txt'
  end

  def run
    check_args
    open_files
    process_uri_file
    write_plain_text_file
  end


private

  def check_args
    begin
      raise arg_error unless ARGV.length == 2
    rescue
      puts $!
      exit
    end
  end

  def open_files
    begin
      @file_in = File.open(ARGV[0], 'r')
      @file_out = File.open(ARGV[1], 'w')
    rescue
      puts "EXCEPTION: #{$!}"
      exit
    end
  end

  def process_uri_file
    @data = ""
    data_array = @file_in.readlines
    data_array.each do |line|
      line = swap_encoding(line) if File.exists?(@translation_file)
      @data += URI.unescape(line)
    end
  end

  def write_plain_text_file
    @file_out.puts @data
  end

  def arg_error
    filename = ($0).split('/').last
    "USAGE: '#{filename} incoming_file outgoing_file'"
  end

  def swap_encoding(line)
    get_translations.each do |trans|
      line.gsub!(trans[0],trans[1])
    end
    line
  end

  def get_translations
    file = open_translation_file
    translation_array = []
    file.readlines.each do |line|
      translation_array << line.split(',')
    end
    translation_array
  end

  def open_translation_file
    begin
      file = File.open(@translation_file)
    rescue
      puts $!
      exit
    end
    file
  end

end

App.new.run

