#!/usr/bin/ruby -w
# Author: Mike Admire
# Synopsis: A command line tool that accepts a filename of a file that has URI encoded
#   text in it and a second filename that will be created by this tool to have the
#   contents of the first file written to it with the URI encoding replaced with plain
#   text.
# Usage:  uri_to_text.rb filename_with_uri filename_with_plain_text
#
require 'uri'

class App

  def initialize
  end

  def run
    check_args
    open_files
    read_uri_text
    write_plain_text
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

  def read_uri_text
    @data = ""
    data_array = @file_in.readlines
    data_array.each do |line|
      @data += URI.unescape(line)
    end
  end

  def write_plain_text
    @file_out.puts @data
  end

  def arg_error
    filename = ($0).split('/').last
    "USAGE: '#{filename} incoming_file outgoing_file'"
  end
end

App.new.run

