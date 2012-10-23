class base(){
  # Common / Shared components don't reorder these
  include stdlib

  # Only other include that should ever be in base is common
  # if it's another module include it from common so all
  # includes are in one place
  include common
}

class media_server(){
  include base

  file { "/etc/media_server/":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755
  }

  file { "/var/log/mediaserver":
    ensure => directory,
    owner => root,
    group => mediaserver,
    mode => 770
  }

  group { "mediaserver":
    ensure => "present",
  }

  class { "sabnzbd":
    listen_port => 9000,
    apikey => $sabnzbd_apikey,
    nzbkey => $sabnzbd_nzbkey,
    webuser => $web_user,
    webpass => $web_pass,
    nntp_hostname => $sabnzbd_nttp_hostname,
    nntp_user => $sabnzbd_nttp_user,
    nntp_pass => $sabnzbd_nttp_pass,
    nntp_ssl => $sabnzbd_nttp_ssl,
    sickbeard_hostname => "localhost",
    sickbeard_user => $web_user,
    sickbeard_pass => $web_pass,
    user => "sabnzbd",
    group => "sabnzbd",
    user_groups => ["mediaserver"],
    base_dir => "/etc/media_server",
    use_couchpotato => 1,
    use_headphones => 1,
    nzbmatrix_username => $sabnzbd_nzbmatrix_username,
    nzbmatrix_password => $sabnzbd_nzbmatrix_password,
    log_path => "/var/log/mediaserver",
    require => [File['/etc/media_server'],Group["mediaserver"]]
  }

  include couchpotato
  include sickbeard
  include headphones

  # File["/etc/media_server"] -> Class["sabnzbd"]

}

class rabbit(){
  include base
  include rabbitmq
}
