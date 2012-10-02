define add_user($id, $ssh_key, $password = "!", $shell = "/bin/bash", $groups = [], $sshkeytype = 'ssh-rsa', $ensure = 'present')  {

  if $ensure == 'absent' {
      User[$name] -> Group[$name]
  }

  user { $name:
    comment => "$name",
    home    => "/home/$name",
    shell   => "$shell",
    uid     => $id,
    gid     => $name,
    managehome => 'true',
    password  => "$password",
    groups => $groups,
    ensure => $ensure
  }

  group { $name:
    ensure => $ensure,
    gid => "$id"
  }

  ssh_authorized_key{ $name: 
    user => "$name",
    ensure => $ensure, 
    type => "$sshkeytype", 
    key => "$ssh_key", 
    name => "$name" 
  } 
}
