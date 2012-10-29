class transmission($download_dir="/mnt/data/Downloads/torrent-incomplete",){ 

  package { ["transmission","transmission-daemon","transmission-cli"]: 
    ensure =>  latest
  } 

  service { "transmission-daemon":
    ensure  => running,
    require => Package["transmission-daemon"],File["/etc/transmission-daemon/settings.json"]
  } 
 
  file { 

    "/etc/transmission-daemon/settings.json":
      ensure  => present, 
      owner   => debian-transmission, 
      group   => mediaserver,
      mode    => 0644, 
      content => template("transmission/settings.json.erb"),
      require => Package["transmission-daemon"]; 
 
    ["/mnt/data/Downloads/torrent-incomplete", "/mnt/data/Downloads/torrent-complete", "/mnt/data/Downloads/torrents"]:
      ensure  => directory,
      owner   => debian-transmission,
      group   => mediaserver,
      mode    => 0755, 
      require => Package["transmission-daemon"]
  }

}
 
