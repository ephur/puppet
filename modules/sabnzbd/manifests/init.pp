class sabnzbd($apikey,$webuser,$listen_port=8080,$webpass,$nntp_hostname,$nntp_user,$nntp_pass,$nzbkey="",$nntp_port=119,
              $nntp_ssl=0,$nntp_connections=10,$nntp_retention=0,$sickbeard_hostname=nil,$sickbeard_ssl=1,
              $sickbeard_port=8081,$sickbeard_user=nil,$sickbeard_pass=nil,$nzbkey=nil, $listen_ip='0.0.0.0',
              $bwlimit="none",$base_dir='/etc/sabnzbd',$user=root,$group=nil,$nzb_upload_dir="",
              $use_couchpotato = 0, $use_headphones=1, $headphones_download_path=nil, $nzbmatrix_username=nil, $nzbmatrix_password=nil,
              $path='usr/local/apps/sabnzbd',$download_path="Downloads",$log_path="/dev/null",$user_groups=[]){

  if $nntp_port == 119 and $nntp_ssl == 1 {
    $use_nntp_port = 563
  } else {
    $use_nntp_port = $nntp_port
  }

  if $use_headphones and ($music_dir == nil) {
    err("when using headphones, you must provide a music dir")
  }

  if $group == nil {
    $use_group = $user
  } else {
    $use_group = $group
  }

  if $base_dir == '/etc/sabnzbd'{
    file { '/etc/sabnzbd':
      path => $base_dir,
      ensure => directory,
      owner => $user,
      group => $use_group,
      mode => 0640
    }
  }

  package {["python","python-cheetah","python-configobj","python-feedparser","python-dbus","python-openssl","python-support","python-yenc","par2","unzip","unrar"]:
    ensure => latest
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
    comment => "User for SABNZBD Service",
    managehome => true,
    shell => "/bin/bash",
    system => true,
    require => Group[$use_group]
  }

  vcsrepo { '/usr/local/apps/sabnzbd':
    ensure   => latest,
    provider => git,
    source   => 'git://github.com/sabnzbd/sabnzbd.git',
    owner => $user,
    group => $use_group,
    require => [User[$user]];
  }

  inittab { 'msn':
    ensure => 'present',
    runlevel => '2345',
    action => 'respawn',
    command => "/bin/su - ${user} -c /usr/bin/sabnzbd.sh",
    require => [File["/usr/bin/sabnzbd.sh"]]
  }

  file {
    "sabnzbd-sabnzbd.ini":
      path => "/${base_dir}/sabnzbd.ini",
      ensure => present,
      owner => $user,
      group => $use_group,
      mode => 0640,
      content => template("sabnzbd/sabnzbd.ini.erb");

    "sabnzbd-post-process-scripts":
      path => "/${base_dir}/post-process-scripts",
      ensure => directory,
      recurse => true,
      owner => $user,
      group => $use_group,
      source => "puppet:///modules/sabnzbd/post-process-scripts",
      mode => 0755;

    "/usr/bin/sabnzbd.sh":
      owner => root,
      group => root,
      mode => 755,
      content => template("sabnzbd/sabnzbd.sh.erb")
   }

  if $sickbeard_hostname != nil {
    if $sickbeard_pass == nil or $sickbeard_user == nil {
      err("password or username not set, disable sickbeard integration or update pass sickbeard_pass and sickbeard_user to the module")
    } else {
      file {
        "sabnzbd_to_sickbeard.ini":
          path => "/$base_dir/sabnzbd_to_sickbeard.ini",
          ensure => present,
          owner => $user,
          group => $use_group,
          mode => 0640,
          content => template("sabnzbd/sabnzbd_to_sickbeard.ini.erb");

        "symlink_sab_nzb_to_sickbeard.ini":
          path => "/${base_dir}/post-process-scripts/autoProcessTV.cfg",
          ensure => link,
          source => "${base_dir}/sabnzbd_to_sickbeard.ini",
          require => [File['sabnzbd_to_sickbeard.ini']];
      }
    }
  }
}