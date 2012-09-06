#!/usr/bin/env ruby

require 'yaml'
require './helpfulfunctions'

include HelpfulFunctions

rc = 1
begin
  in_file = ARGV[0]
  name    = ARGV[1]
  if not (in_file and name)
    raise "usage: #{$0} /path/to/input.yaml package"
  end

  hash    = YAML.load_file(in_file)['packages']
  version = lookup_version hash, name

  if audit_package(name, version, false)
    rc = 0
  else
    $stderr.puts "err: #{name} should be version #{version}"
  end
rescue Exception => e
  $stderr.puts e.message
end
exit rc