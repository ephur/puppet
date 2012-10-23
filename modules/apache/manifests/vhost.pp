define apache::vhost($priority=10, $ensure = 'present') {

  include apache

  file { "${priority}-${name}.conf":
    ensure  => $ensure,
    path    => "/etc/apache2/sites-enabled/${priority}-${name}.conf",
    content => template("apache/vhosts/${name}"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [Package['apache2']],
    notify  => Service['apache2'],
  }
}