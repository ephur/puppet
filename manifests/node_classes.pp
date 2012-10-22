class base(){
  # Common / Shared components don't reorder these
  include stdlib

  Vcsrepo {
    provider => git
  }

  # Only other include that should ever be in base is common
  # if it's another module include it from common so all
  # includes are in one place
  include common
}

class media_server(){
  File["media_server"] -> Class["sabnzbd"]
  include base

  file { "/etc/media_server":
    ensure => directoy,
    owner => root,
    group => root,
    mode => 755
  }

  class { "sabnzbd":
    apikey => $sabnzbd_apikey,
    nzbkey => $sabnzbd_nzbkey,
    webuser => $web_user,
    webpass => $web_pass,
    nntp_hostname => $sabnzbd_nttp_hostname,
    nntp_user => $sabnzbd_nttp_user,
    nntp_pass => $sabnzbd_nttp_pass,
    nntp_ssl => $sabnzbd_nttp_ssl,
    sickbeard_hostname => "localhost",
    user => "sabnzbd",
    group => "sabnzbd",
    base_dir => "/etc/media_server",
    require => [File['/etc/media_server']]
  }

  include couchpotato

  include sickbeard

  include headphones
}

class rabbit(){
  include base
  include rabbitmq
}
