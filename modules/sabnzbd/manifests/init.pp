class sabnzbd($apikey,$webuser,$webpass,$nntp_hostname,$nntp_user,$nntp_pass,$nzbkey="",$nntp_port=119,
              $nntp_ssl=0,$nntp_connections=10,$nntp_retention=0,$sickbeard_hostname=nil,$sickbeard_ssl=1,
              $sickbeard_port=8081,$sickbeard_user=nil,$sickbeard_pass=nil,$nzbkey=nil,
              $bwlimit="none",$base_dir='/etc/sabnzbd',$user=root,$group=nil,$nzb_upload_dir=""){

  if $nntp_port == 119 and $nntp_ssl == 1 {
    $nntp_port = 563
  }

  if $group == nil {
    $group = $user
  }

  if $base_dir == '/etc/sabnzbd'{
    file { $base_dir:
      ensure => directory,
      owner => $user,
      group => $user,
      mode => 0640
    }
  }

  vcsrepo { '/usr/local/apps/sabnzbd':
    ensure   => latest,
    provider => git,
    source   => 'git://github.com/sabnzbd/sabnzbd.git',
    owner => $user,
    group => $group,
    user => $user,
    require => [User[$user]];
  }

  file { "${base_dir}/sabnzbd.ini":
    ensure => present,
    owner => $user,
    group => $group,
    mode => 0640,
    content => template("sabnzbd/sabnzbd.ini.erb");

    '${base_dir}/post-process-scripts':
      ensure => directory,
      recurse => true,
      owner => $user,
      group => $group,
      source => "puppet:///modules/sabnzbd/post-process-scripts",
      mode => 0755;
   }

  if $sickbeard_hostname != nil {
    if $sickbeard_pass == nil or $sickbeard_user ==nil {
      err("password or username not set, disable sickbeard integration or update pass sickbeard_pass and sickbeard_user to the module")
    } else {
      file {
        "${base_dir}/sab_nzb_to_sickbeard.ini":
          ensure => present,
          owner => $user,
          group => $group,
          mode => 0640,
          content => template("sabnzbd/sab_nzb_to_sickbeard.ini.erb");

        '${base_dir}/post-process-scripts/autoProcessTV.cfg':
          ensure => symlink,
          owner => $user,
          group => $group,
          source => '${base_dir}/sab_nzb_to_sickbeard.ini';
      }
    }
  }
}