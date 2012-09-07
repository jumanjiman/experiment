experiment
==========

[YAML](http://yaml.org) ain't markup language.
Instead, it's a "human friendly data serialization standard for all programming languages".

Explore yaml to store config data.

* replace `params.pp` files in puppet; use [hiera](http://www.devco.net/archives/2011/06/06/puppet_backend_for_hiera.php) to store parameters
* replace CSV file, such as network IPs, etc.

Benefits:

* explicitly separate data from tools, such that **multiple tools** can parse the data *as needed*
* facilitate common config data sources across all teams, including
  - networks
  - linux
  - windows
* many languages have libraries for reading yaml files
  - ruby
  - python
  - powershell via [PowerYaml](https://github.com/scottmuc/PowerYaml)
  - etc.

Example python code:

```python
#!/usr/bin/env python

import yaml

def construct_ruby_object(loader, suffix, node):
    return loader.construct_yaml_map(node)

def construct_ruby_sym(loader, node):
    return loader.construct_yaml_str(node)

yaml.add_multi_constructor(u"!ruby/object:", construct_ruby_object)
yaml.add_constructor(u"!ruby/sym", construct_ruby_sym)
stream = file('201203130939.yaml','r')
mydata = yaml.load(stream)
print mydata
```

Packages in YAML
----------------

This repo demonstrates one approach i'm exploring (to move data from puppet to yaml).

Using the files in the `/src` directory, you could run:

    ./demo.rb authorized-packages-Fedora17.yaml install-packages.yaml

and simulate creation of puppet package resources.
Of course, in real life we'd use a custom function in a puppet module
to create the resources. This is just to explore a simpler
data structure than hiera or the
[`create_resources`](http://docs.puppetlabs.com/references/latest/function.html#createresources) built-in function.

The idea behind this experiment is to have two files:

* A yaml file that contains canonical versions of authorized packages
  - the file's name should reflect its overall version, such as `Fedora17.yaml`
* A yaml file that contains a list of packages to actually install


```puppet
  package {'aalib-libs':
    ensure => '1.4.0-0.20.rc5.fc17',
  }
  package {'abattis-cantarell-fonts':
    ensure => '0.0.8-1.fc17',
  }
  package {'vim-common':
    ensure => '7.3.638-2.fc17',
  }
  package {'vim-enhanced':
    ensure => '7.3.638-2.fc17',
  }
  package {'vim-filesystem':
    ensure => '7.3.638-2.fc17',
  }
  package {'vim-minimal':
    ensure => '7.3.638-2.fc17',
  }
  package {'foobar':
    ensure => 'absent',
  }
  package {'emacs':
    ensure => 'absent',
  }
```


WRT separating data from puppet, see also:
------------------------------------------

* http://puppetlabs.com/blog/the-problem-with-separating-data-from-puppet-code

    > While there are a myriad of options to solve the problem of configuration data and Puppet code separation, we recommend using Hiera for its ability to adapt to every situation. This post only gives a brief glimpse of its awesome functionality. Stay tuned for a post dedicated to Hiera, where we will be looking in-depth at its usage, flexibility, and advanced features that can simplify the management of your environment whether you’re a sysadmin of 10, 100, or 10,000 nodes!

* http://nuknad.com/2011/05/10/puppet-lessons-learned

    > Puppet has data, like the ip address of your load balancer for example. You could include data straight in your manifests, but, this would be a mistake. Separate your code from your data. Currently, ext-lookup is a good solution for this, but I believe puppet is looking at restructuring the way code and data and separated, so keep a lookout on the best practice for this.

...and other references via [a Google search](https://www.google.com/search?ix=seb&sourceid=chrome&ie=UTF-8&q=separate+data+from+puppet)

manipulate network configs
--------------------------

icfg:

* https://fedorahosted.org/icfg/
* http://git.fedorahosted.org/git/?p=icfg.git;a=blob_plain;f=src/icfg;hb=HEAD
