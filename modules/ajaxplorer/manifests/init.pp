class ajaxplorer(){

  file { "/etc/apt/sources.list.d/ajaxplorer.list":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 644,
    content => "deb http://dl.ajaxplorer.info/repos/apt ${lsbdistcodename} main",
    require => Exec["ajaxplorer-apt-key"]
  }

  exec { "ajaxplorer-apt-key":
    command => "/usr/bin/wget -O- http://dl.ajaxplorer.info/repos/charles@ajaxplorer.info.gpg.key | /usr/bin/apt-key add -",
    unless => "/usr/bin/apt-key list | /bin/grep 2048R/11FFD694",
    path => ["/bin", "/usr/bin"],
    timeout => "10",
  }


  exec { "ajaxplorer-apt-update":
    command => "/usr/bin/apt-get update",
    path => ["/bin", "/usr/bin"],
    subscribe => [Exec[ajaxplorer-apt-key],File["/etc/apt/sources.list.d/ajaxplorer.list"]],
    refreshonly => true
  }

  package { "ajaxplorer":
    ensure => latest
  }

}