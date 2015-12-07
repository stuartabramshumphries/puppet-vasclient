# == Class: vasclient
#
# installs quest vasclient AD tools for linux and joins the server to domain
#
# === Parameters
#
# [autoupdate]
#   Will set the module to automatically update the packages it installs.
# [service_ensure]
#   Set the service the module is responsible for to that state.
# [package]
#   The package to install
# [svc_name]
#   The name of the service in init.d that we are running
# [domain]
#   Active directory domain to join
# [username]
#   The user name to use to join the AD domain above
# [password]
#   Password for the user above
#
# === Variables
#
#   NA
#
# === Examples
#
# include vasclient
#
# class { "vasclient":
#   domain   => 'mydomain.com',
#   username => 'admin',
#   password => 'secretpassword',
# }
#
# === Authors
#
# stuartabramshumphries@gmail.com
#
# [Remember: No empty lines between comments and class definition]
class vasclient(
  # Mandatory
  $enable,
  $password,

  # Optional
  $domain    = $vasclient::params::domain,
  $joinou    = $vasclient::params::joinou,

  $package   = $vasclient::params::package,
  $svc_name  = $vasclient::params::svc_name,
  $username  = $vasclient::params::username,
) inherits vasclient::params{

  case $enable {
    false: {
      $ensure  = absent
      $symlink = absent
    }
    default: {
      $ensure  = present
      $symlink = link
    }
  }

  if $enable {

    package { $package:
      ensure => present,
    }

    file { '/etc/krb5.conf':
      ensure => $symlink,
      target => '/etc/opt/quest/vas/vas.conf',
    }

    service { $svc_name:
      ensure  => running,
      require => Package[$package],
    }
# this bit is funky; essentially on first run we want the preflight check to pass
# on subsequent runs, we dont want to run the command vastool.. if the vas.conf exists
    exec { 'join_domain':
      command => "/opt/quest/bin/vastool -u ${username} -w \'${password}\' join -c \"${joinou}\" -f ${domain}",
      require => Package[$package],
      creates => '/etc/opt/quest/vas/vas.conf',
      onlyif  => "/opt/quest/bin/preflight -u ${username} -w \'${password}\' ${domain}",
    }
  }
  else {
    notify{'Module vasclient is disabled on this host':}
  }
}
