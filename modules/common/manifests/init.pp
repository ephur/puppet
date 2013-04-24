class common(){

  $lc_operatingsystem = downcase($operatingsystem)

  # Ensure packages
  case $operatingsystem {
    "Debian","Ubuntu": {
      package { ["curl", "wget", "vim", "git", "telnet", "ntp"]:
        ensure => latest
      }

      file { "/etc/apt/sources.list":
        ensure => present,
        owner => root,
        group => root,
        mode => 0644,
        content => template("common/${lc_operatingsystem}/sources.list.erb")
      }
    }
  }

  # Setup sudo
  package { "sudo":
    ensure => latest
  }

  file { "/etc/sudoers":
    ensure => present,
    owner => root,
    group => root,
    mode => 0440,
    content => template("common/${lc_operatingsystem}/sudoers.erb")
  }

  # Setup users
  add_user { ephur:
    ensure => present,
    id => 1000,
    groups => ["sudo"],
    ssh_key => "AAAAB3NzaC1yc2EAAAADAQABAAAEAQDTFIKplfEUHMXBTJLvQunrYJ+t8ENY/SPqVBCxeGPmaa4dPhczAeXWlxjrbtfJwPS29AHIdr0VaUkKcpSK1OYiMLwfQOb8Zdydv3l63ENaWp7W9Ayf16Ifpt0Xtfb0dKJK2uA7etvZdqsaXOCJIjHgj1BvQrUal0gRpf3v86goqRK/Wf4+ghoXGcM66+Xh0Oea9zf9bcjd1zRIRbJwLPrK7emottv9MF01CWwDt5DqzOTiPNm8kpb3W7s82MvtsT9NjUFPcvETYXi7KqP/ZG+1vl7/76TdA+GdRKRha4BQi8vF5OIxQXSPcwRAbQjr1Q9dX7/eR17Qf6QOQ6yYLcQ5zClxkGufnUB+vxhj5dZflCjS7i6bOhycmSYsuxAkcBSAzS7jjKGZFUqOWNL3HVuovPkW4WGTyfszQ8Je6c6iTXkxEUP3jkjeOMzSoCd9Dj+XiN1T7ppYAp6i+2vVBiwOkAysEmCg2FD4HW6lpB31CmYZN653Q+MWSjtO47ffAZO55h9r3AsdnM7dxrKGDUCuS9HXhd/l8aUaiFlj8hgks6vPplry/qU/O6GJxgOGYFoaJYIr5IpSqiQuA1YLH9pdX0x8mioeSbqPes976kNdT3lQtFOO5IiFMwy02Hwe98UNy0kguILqJPCM9EIAMDRIfwx7bKS3c3Y7YuMnNZYyiUi3nFzTPRACX759OOIDYAcAE+sNXNmqPk9EZILu9F2KOT45s85BqXlriec+HZgOPSP91u9Pw+Fsfj5Y7W1cW4XuzZzQu9pPB21qZbxhVF0Xa76UL26Fyew1JcvLz/8YcM+NGUJW3uvcjiJo+oaeo2VgMyad/QJDG+9W++RGfRslA0urlNv8+z9GoCaGY6EPLsm5tjbwLgIihxFINNeHQdZGVRsvu6Zyr2H0/6MEM4qY4fOESQp6mkNTpLtmCgRABvCnn/kMKGyT3ccYNkUUys/y9drfRbbyhbwdUGrSWOYZlfGKb6kqGNe1B4g5gpUuq9WAw/sY3Ix3ttYUzo715omdMSlHi6pCXUdiO9ciOowGMj3+FMzlDxHCsPchZvZdoHSu+3psc5KZBmX84pfDiJ9An5NLjyVFN3P9JO/qqL+pJZMoNMTuAKzM2t1A+0xCpie4G4bj3ME+WxqXeezxBujuosdaGCQvd522YfxCTFLYWPaLVnBweF3TbdycH8QqfqlWlbTKFXtSQu4Nk5HLrSjd9ACRTR3tZ5BUC+0RrF45S7qHPyfj1ti55q8RqlaYQhEifIC5/8noEUlwCcsbkmew38sGoFbs1zL+g4QRP5+IJsehScL9nHD49MPSemVBr1MSVbp1wdtwiyEjNVpoffdLWh8YPPsQyLUQ8a0Dc7qZ"
  }
}
