
class puppet ($facter_versio=latest, $puppet_version=latest, $use_mcollective=false, $mcollective_version=latest) { 

  case $operatingsystem { 
  
    debian: { 

      # Some versions of facter do not set this fact, so a small work around is needed
      # for backward compatibility, in particular because this module will be 
      # responsible for upgraging facter....

      if $lsbdistcodename == undef { 
        case $operatingsystemrelease { 
          /^5\..*/: { 
            $lsbdistcodename = "lenny"
          } 
      
          /^6\..*/: { 
            $lsbdistcodename = "squeeze"
          }
        }
      } 

      file { "/etc/apt/sources.list.d/puppetlabs.list": 
        ensure => present, 
        owner => "root", 
        group => "root", 
        mode => 644,
        content => "deb http://apt.puppetlabs.com ${lsbdistcodename} main",
        require => Exec["puppet-apt-key"]
      } 

      exec { "puppet-apt-key": 
        command => "/usr/bin/wget -O- https://apt.puppetlabs.com/pubkey.gpg | /usr/bin/apt-key add -",
        unless => "/usr/bin/apt-key list | /bin/grep 4096R/4BD6EC30",
        path => ["/bin", "/usr/bin"],
        timeout => "10", 
      }

      exec { "puppet-apt-update": 
        command => "/usr/bin/apt-get update",
        path => ["/bin", "/usr/bin"], 
        subscribe => [Exec[puppet-apt-key],File["/etc/apt/sources.list.d/puppetlabs.list"]],
        refreshonly => true
      }
        
      package { ["puppet-common","puppet"]: 
        ensure => $puppet_version,
        require => [File["/etc/apt/sources.list.d/puppetlabs.list"],Exec["puppet-apt-update"]], 
      }

      package { "facter":
        ensure => $facter_version, 
        require => [File["/etc/apt/sources.list.d/puppetlabs.list"],Exec["puppet-apt-update"]], 
      }

      $min1 = fqdn_rand( 30 )
      $min2 = $min1 + 30

      # Cron
      cron { "puppet-agent":
        command => "/usr/bin/puppet agent --no-daemonize -o >/dev/null 2>&1",
        user  => root,
        minute  => [ $min1, $min2 ],
        require => Package["puppet"]
      }

      if ($use_mcollective) { 
        package { ["mcollective", "mcollective-common"]:
          ensure => $mcollective_version, 
          require => [File["/etc/apt/sources.list.d/puppetlabs.list"],Exec["puppet-apt-update"]], 
        } 
      }
     
    } 

    default: { 
      err("${fqdn} is running unsupported operating ${operatingsystem}")
    }
  }
}
