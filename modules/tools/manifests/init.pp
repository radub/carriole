class tools {

  # package install list
  $packages = [
    "curl",
    "vim",
    "htop",
    "git-core"
  ]

  # install packages
  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }

  # install composer globaly
  exec { 'composer-install':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    path    => '/usr/bin:/usr/sbin',
    require => Package['curl'],
  }

}
