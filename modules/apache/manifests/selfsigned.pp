define apache::selfsigned(
  $cert_country,
  $cert_state,
  $cert_location,
  $cert_org,
  $cert_orgunit,
  $cert_cn){

  file {
    "/usr/bin/generate_self_signed.sh":
      ensure => present,
      owner => root,
      group => root,
      mode => 0755,
      content => template("generate_self_signed.sh.erb")
  }

  exec {
    "/usr/bin/generate_self_signed.sh":
      creates => "/etc/apache2/ssl/${cert_cn}.csr",
  }
}