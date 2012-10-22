class sabnzbd(){ 
  vcsrepo { '/usr/local/apps/sabnzbd':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/sabnzbd/sabnzbd.git'
  }
}
