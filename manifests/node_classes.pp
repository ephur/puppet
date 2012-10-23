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
      mode => 0755;

    "/mnt/data/":
      ensure => directory,
      owner => root,
      group => mediaserver,
      mode => 0770;

    "/var/log/mediaserver":
      ensure => directory,
      owner => root,
      group => mediaserver,
      mode => 0770;

    "/mnt/data/Downloads/Music":
      ensure => directory,
      owner => "sabnzbd",
      group => "mediaserver",
      require => [Class["sabnzbd","headphones"]],
      mode => 0775;

    "/mnt/data/Music":
      ensure => directory,
      owner => "headphones",
      group => "headphones",
      mode => 0775;
  }

  group { "mediaserver":
    ensure => "present",
  }

  add_user { "$unix_user":
    ensure => present,
    id => $unix_user_id,
    ssh_key => $unix_user_pubkey,
    groups => ['mediaserver']
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
    base_dir => "/etc/media_server",
    download_path => "/mnt/data/Downloads/Music",
    music_dir => "/mnt/data/Music",
    user => "headphones",
    group => "headphones",
    user_groups => ["mediaserver"],
    nzbmatrix_apikey => $nzbmatrix_password,
    nzbmatrix_username => $nzbmatrix_username,
    hp_username => $musicbrain_vip_username,
    hp_password => $musicbrain_vip_password,
    sabnzbd_server => "https://localhost:9000",
    require => [File['/etc/media_server'],Group["mediaserver"]]
  }

  apache::selfsigned($cert_country => "US",
  $cert_state => "Texas",
  $cert_location => "San Antonio",
  $cert_org => "Personal",
  $cert_orgunit => "Personal Cloud",
  $cert_cn => "carrots.ephur.net" )

  apache::vhost("carrots.ephur.net")

  include couchpotato
  include sickbeard
  include headphones
}

class rabbit(){
  include base
  include rabbitmq
}
