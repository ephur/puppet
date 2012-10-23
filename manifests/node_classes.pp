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

  file {
    "/etc/media_server/":
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,

    "/mnt/data/":
      ensure => directory,
      owner => root,
      group => mediaserver,
      mode => 770;

    "/var/log/mediaserver":
      ensure => directory,
      owner => root,
      group => mediaserver,
      mode => 770;

    "/mnt/data/Music":
      ensure => directory,
      owner => "headphones",
      group => "headphones"
      mode => 0775;
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
    nzbmatrix_username => $nzbmatrix_username,
    nzbmatrix_password => $nzbmatrix_password,
    log_path => "/var/log/mediaserver",
    download_path => "/mnt/data/Downloads",
    require => [File['/etc/media_server'],Group["mediaserver"]]
  }

  class { "headphones":
    listen_port => 9001,
    apikey => $headphones_apikey,
    sabnzbd_apikey => $sabnzbd_apikey,
    http_username => $web_user,
    http_password => $web_pass,
    download_path => "/mnt/data/Downloads/Music",
    music_dir => "/mnt/data/Music",
    user => "headphones",
    group => "headphones",
    user_groups => ["mediaserver"],
    nzbmatrix_password => $nzbmatrix_password,
    nzbmatrix_username => $nzbmatrix_username,
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
