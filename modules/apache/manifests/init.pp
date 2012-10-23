class apache(){

  package { ['apache2']:
    ensure => latest;
  }

  service { 'apache2':
    ensure    => running,
    enable    => true,
    subscribe => Package['apache2'];
  }

  file { '/etc/apache2/ssl':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0640';
  }

  a2mod { ['proxy','ssl']:
    ensure => present,
    notify => Service['apache2'];
  }

}