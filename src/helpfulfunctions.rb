#!/usr/bin/env ruby

module HelpfulFunctions
  def hash2puppet(hash)
    # convert hash of rpm:version into puppet declarations
    hash.each do |rpm, version|
      puts %Q!  package {'#{rpm}':!
      puts %Q!    ensure => '#{version}',!
      puts %Q!  }!
    end
  end

  def lookup_version(hash, name)
    # for package 'name', return the version from hash
    raise 'missing package name' unless name
    raise 'missing hash in package_name:version format' unless hash
    return hash[name]
  end

  def installed_version(name)
    # ignore epoch for now
    actual = %x!rpm -q --qf '%{version}-%{release}' #{name}!
    if  /is not installed/.match(actual)
      actual = '' if  /is not installed/.match(actual)
    end
    return actual
  end

  def audit_package(name, version, optional=true)
    actual = installed_version(name)
    if optional
      rc = (actual == version or actual == '')
    else
      rc = (actual == version)
    end
    return rc
  end

  def audit_packages(hash, optional=true)
    rc = 0
    errs = []
    $stderr.print 'Auditing packages'
    hash.each do |name, version|
      if audit_package(name, version, optional)
        $stderr.print '.'
      else
        $stderr.print 'x'
        errs << "#{name} should be #{version}"
        rc = 1
      end
    end
    $stderr.puts ''
    if rc == 0
      $stderr.puts 'All good'
    else
      $stderr.puts errs.join("\n")
    end
    return rc
  end
end