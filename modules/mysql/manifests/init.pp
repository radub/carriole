class mysql {

  # mysql root password
  $mysqlpw = "mysql123"

  # install mysql server
  package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"]
  }

  # install mysql client
  package { "mysql-client":
    ensure => present,
    require => Exec["apt-get update"]
  }

  # start mysql service
  service { "mysql":
    ensure => running,
    require => Package["mysql-server"],
  }

  # set mysql password
  exec { "set-mysql-password":
    unless => "mysqladmin -uroot -p$mysqlpw status",
    command => "mysqladmin -uroot password $mysqlpw",
    require => Service["mysql"],
  }
}
