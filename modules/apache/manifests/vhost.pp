define apache::vhost($priority=10, $ensure = 'present') {

  include apache

  if $ensure == 'present'{
    $content = template("apache/vhosts/${name}")
  } else {
    $content = ""
  }

  file { "${priority}-${name}":
    ensure  => $ensure,
    path    => "/etc/apache2/sites-enabled/${priority}-${name}",
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [Package['apache2']],
    notify  => Service['apache2'],
  }
}