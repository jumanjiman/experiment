#!/usr/bin/env ruby

require 'yaml'
require './helpfulfunctions'

include HelpfulFunctions

rc = 1
begin
  in_file = ARGV[0]
  raise "usage: #{$0} /path/to/input.yaml" unless in_file
  rc = audit_packages YAML.load_file(in_file)['packages']
rescue Exception => e
  $stderr.puts e.message
end
exit rc