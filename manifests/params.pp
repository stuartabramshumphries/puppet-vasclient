# == Class: vasclient::params
#
class vasclient::params{

  $domain   = 'domain.local'
  $joinou   = 'OU=VCD,OU=Linux Servers,OU=Servers,OU=Infrastructure,OU=DOMAIN,DC=domain,DC=local'
  $package  = 'vasclnt'
  $svc_name = 'vasd'
  $username = 'vcdlinuxjoin'

}
