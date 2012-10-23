class apache(){
  package { ["apache2"]:
    ensure => latest,
  }

  service { "apache2":
    ensure => running,
    enable => true,
    subscribe => Package['apache2']
  }

  a2mod { "proxy":
    ensure => present
  }
}