class sabnzbd($apikey,$webuser,$webpass,$nntp_hostname,$nntp_user,$nntp_pass,$nzbkey="",$nntp_port=119,
              $nntp_ssl=0,$nntp_connections=10,$nntp_retention=0,$sickbeard_hostname=nil,$sickbeard_ssl=1,
              $sickbeard_port=8081,$sickbeard_user=nil,$sickbeard_pass=nil,$nzbkey=nil,
              $bwlimit="none",$base_dir='/etc/sabnzbd',$user=root,$group=nil,$nzb_upload_dir="",
              $use_couchpotato = 0, $use_headphones =0,
              $path='usr/local/apps/sabnzbd'){

  if $nntp_port == 119 and $nntp_ssl == 1 {
    $use_nntp_port = 563
  } else {
    $use_nntp_port = $nntp_port
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

  group { $use_group:
    ensure => present,
    system => true
  }

  user { $user:
    ensure => present,
    gid => $user,
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

   }

  file {
    "/tmp/debug":
      ensure => present,
      content => $sickbeard_hostname
  }

  if $sickbeard_hostname != nil {
    if $sickbeard_pass == nil or $sickbeard_user == nil {
      err("password or username not set, disable sickbeard integration or update pass sickbeard_pass and sickbeard_user to the module")
    } else {
      file {
        "sab_nzb_to_sickbeard.ini":
          path => "/$base_dir/sab_nzb_to_sickbeard.ini",
          ensure => present,
          owner => $user,
          group => $use_group,
          mode => 0640,
          content => template("sabnzbd/sab_nzb_to_sickbeard.ini.erb");

        "symlink_sab_nzb_to_sickbeard.ini":
          path => "/${base_dir}/post-process-scripts/autoProcessTV.cfg",
          ensure => symlink,
          owner => $user,
          group => $use_group,
          source => "/${base_dir}/sab_nzb_to_sickbeard.ini",
          require => [File['sab_nzb_to_sickbeard.ini']];
      }
    }
  }
}