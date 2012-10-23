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
    sickbeard_user => $web_user,
    sickbeard_pass => $web_pass,
    user => "sabnzbd",
    group => "sabnzbd",
    base_dir => "/etc/media_server",
    use_couchpotato => 1,
    use_headphones => 1,
    nzbmatrix_username => $sabnzbd_nzbmatrix_username,
    nzbmatrix_password => $sabnzbd_nzbmatrix_password,
    require => [File['/etc/media_server']]
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
