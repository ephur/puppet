class sickbeard(){ 
  vcsrepo { '/usr/local/apps/sickbeard':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/midgetspy/Sick-Beard.git'
  }
}
