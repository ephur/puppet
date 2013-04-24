
class cloud-monitoring-agent ($facter_versio=latest, $cloudmonitoring_version=latest) { 

  case $operatingsystem { 
  
    'Ubuntu': { 

      # Some versions of facter do not set this fact, so a small work around is needed
      # for backward compatibility, in particular because this module will be 
      # responsible for upgraging facter....


      file { "/etc/apt/sources.list.d/cloudmonitoring.list": 
        ensure => present, 
        owner => "root", 
        group => "root", 
        mode => 644,
        content => "deb http://stable.packages.cloudmonitoring.rackspace.com/ubuntu-${lsbdistrelease}-x86_64 cloudmonitoring main",
        require => Exec["cloudmonitoring-apt-key"]
      } 

      exec { "cloudmonitoring-apt-key": 
        command => "/usr/bin/wget -O- https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc | /usr/bin/apt-key add -",
        unless => "/usr/bin/apt-key list | /bin/grep 4096R/4BD6EC30",
        path => ["/bin", "/usr/bin"],
        timeout => "10", 
      }

      exec { "cloudmonitoring-apt-update": 
        command => "/usr/bin/apt-get update",
        path => ["/bin", "/usr/bin"], 
        subscribe => [Exec[cloudmonitoring-apt-key],File["/etc/apt/sources.list.d/cloudmonitoringlabs.list"]],
        refreshonly => true
      }
        
      package { ["cloudmonitoring-common","cloudmonitoring"]: 
        ensure => $cloudmonitoring_version,
        require => [File["/etc/apt/sources.list.d/cloudmonitoringlabs.list"],Exec["cloudmonitoring-apt-update"]], 
      }
     
    } 

    default: { 
      err("${fqdn} is running unsupported operating ${operatingsystem}")
    }
  }
}
