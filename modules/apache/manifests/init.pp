class apache {

  # install apache
  package { "apache2":
    ensure => present,
    require => Exec["apt-get update"]
  }

  # ensures that mode_rewrite is loaded and modifies the default configuration file
  file { "/etc/apache2/mods-enabled/rewrite.load":
    ensure => link,
    target => "/etc/apache2/mods-available/rewrite.load",
    require => Package["apache2"]
  }

  # create directory
  file {"/etc/apache2/sites-enabled":
    ensure => directory,
    recurse => true,
    purge => true,
    force => true,
    before => File["/etc/apache2/sites-enabled/web.conf"],
    require => Package["apache2"],
  }

  # create apache config from main vagrant manifests
  file { "/etc/apache2/sites-available/web.conf":
    ensure => present,
    source => "/vagrant/vm-pp/manifests/assets/vhost.conf",
    require => Package["apache2"],
  }

  # symlink apache site to the site-enabled directory
  file { "/etc/apache2/sites-enabled/web.conf":
    ensure => link,
    target => "/etc/apache2/sites-available/web.conf",
    require => File["/etc/apache2/sites-available/web.conf"],
    notify => Service["apache2"],
  }

  # starts the apache2 service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { "apache2":
    ensure => running,
    require => Package["apache2"],
    subscribe => [
      File["/etc/apache2/mods-enabled/rewrite.load"],
      File["/etc/apache2/sites-available/web.conf"]
    ],
  }

  file {"/var/www/web":
    ensure => "link",
    target => "/vagrant/app",
    require => Package["apache2"],
    notify => Service["apache2"],
    replace => yes,
    force => true,
  }


#exec { "ApacheUserChange" :
#  command => "/bin/sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
#  onlyif  => "/bin/grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}
#
#exec { "ApacheGroupChange" :
#  command => "/bin/sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
#  onlyif  => "/bin/grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}
#
#exec { "apache_lockfile_permissions" :
#  command => "/bin/chown -R vagrant:www-data /var/lock/apache2",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}
#

}