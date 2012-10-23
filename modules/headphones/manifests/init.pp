class headphones($username,$listen_port,$http_username,$http_password,
	               $music_dir,$nzbmatrix_username,$nzbmatrix_password,
	               $listen_ip='0.0.0.0',$base_dir='/etc/headphones',
                 $group=nil,$user_groups=[],$app_path="usr/local/apps/headphones",
                 $log_path="/dev/null",$download_path="/dev/null",
                 $cache_dir=nil,$sabnzbd_apikey=""){

	if $group == nil {
    $use_group = $user
  } else {
    $use_group = $group
  }

  if $base_dir == '/etc/headphones'{
    file { '/etc/headphones':
      path => $base_dir,
      ensure => directory,
      owner => $user,
      group => $use_group,
      mode => 0640
    }
  }

  package { "ffmpeg":
    ensure   => latest,
  }

  vcsrepo { '/usr/local/apps/headphones':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/rembo10/headphones.git'
  }

  inittab { 'mhp':
    ensure => 'present',
    runlevel => '2345',
    action => 'respawn',
    command => "/bin/su - ${user} -c /usr/bin/headphones.sh",
    require => [File["/usr/bin/headphones.sh"]]
  }

  file {
    "/usr/bin/headphones.sh":
      ensure => present,
      owner => root,
      group => root,
      mode => 755,
      content => template("headphones/headphones.sh.erb");

	  "/${base_dir}/headphones.ini":
	    ensure => presnent,
	    owner => headphones,
	    group => headphones,
	    mode => 640,
	    content => template("headphones/headphones.ini.erb")
	}

	group { $use_group:
    ensure => present,
    system => true
  }

  user { $user:
    ensure => present,
    gid => $user,
    groups => $user_groups,
    home => "/home/$user",
    comment => "User for headphones Service",
    managehome => true,
    shell => "/bin/bash",
    system => true,
    require => Group[$use_group]
  }

}
