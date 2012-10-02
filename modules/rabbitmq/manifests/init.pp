class rabbitmq($version='latest'){
  package { rabbitmq-server:
    ensure => $version
  }

  service { rabbitmq-server:
    ensure => running,
    require => Package["rabbitmq-server"]
  }

  rabbit_vhost { test:
    ensure => present,
    require => Service["rabbitmq-server"]
  }

  rabbit_user { test:
    ensure => present,
    password => "test",
    require => Service["rabbitmq-server"]
  }

}
