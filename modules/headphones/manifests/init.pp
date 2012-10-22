class headphones(){ 
  vcsrepo { '/usr/local/apps/headphones':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/rembo10/headphones.git'
  }
}
