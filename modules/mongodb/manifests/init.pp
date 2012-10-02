class mongodb() {

  case $operatingsystem { 
  
    debian: { 
   
      file { "/etc/apt/sources.list.d/tengen.list":
        ensure => present,
        owner => "root",
        group => "root", 
        mode => 644, 
        content => "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen", 
        require => Exec["mongo-apt-key"]
      }

      exec { "mongo-apt-key": 
        command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
        unless => "/usr/bin/apt-key list | /bin/grep 7F0CEB10", 
        path => ["/bin", "/usr/bin"], 
        timeout => 10, 
      } 
 
      exec { "mongo-apt-update":
        command => "/usr/bin/apt-get update", 
        path => ["/bin", "/usr/bin"], 
        subscribe => [Exec["mongo-apt-key"],File["/etc/apt/sources.list.d/tengen.list"]],
        refreshonly => true
      }

      package { "mongodb-10gen":
        ensure => present,
        require => [Exec["mongo-apt-update"],File["/etc/apt/sources.list.d/tengen.list"]],
      }
    }
  }
}
   
