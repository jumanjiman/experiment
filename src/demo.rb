#!/usr/bin/env ruby

# this script is for exploring a simplified data structure that can live outside puppet and be used by puppet
# as well as other tools

require 'yaml'

begin
  # get arguments
  authorized_packages_file = ARGV[0]
  install_packages_file    = ARGV[1]
  if not (ARGV[0] and ARGV[1])
    raise "usage: #{$0} authorized_packages_file install_packages_file"
  end

  # read files into hashes
  authorized_packages = YAML.load_file(authorized_packages_file)['packages']
  y                   = YAML.load_file(install_packages_file)
  install_packages    = y['packages']
  blacklist_packages  = y['blacklist']

  # copy version from authorized_packages into install_packages
  install_packages.keys.each do |key|
    if authorized_packages[key]
      install_packages[key] = authorized_packages[key]
    else
      install_packages[key] = 'absent'
    end
  end

  # remove packages (and override package versions from above if blacklisted)
  blacklist_packages.keys.each do |key|
    install_packages[key] = 'absent'
  end

  # print puppet resource (in puppet, we'd use a function to generate the resource)
  install_packages.each do |rpm, ver|
    puts %Q!  package {'#{rpm}':!
    puts %Q!    ensure => '#{ver}',!
    puts %Q!  }!
  end

rescue Exception => e
  $stderr.puts e.message
  exit 1
end
