class couchpotato(){ 
  vcsrepo { '/usr/local/apps/couchpotato':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/RuudBurger/CouchPotato.git'
  }
}
