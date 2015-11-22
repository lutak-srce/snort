# Class: snort
#
# This module manages snort package
#
class snort::pulledpork (
  $oinkcode       = $snort::params::oinkcode,
  $ppork_ignore   = $snort::params::ppork_ignore,
) inherits snort::params {
  package { 'pulledpork':
    ensure  => present,
  }
  file { '/etc/pulledpork/pulledpork.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('snort/pulledpork.conf.erb'),
    require => Package['pulledpork'],
  }
  file { '/etc/pulledpork/disablesid.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => [
      'puppet:///private/snort/disablesid.conf',
      'puppet:///modules/snort/disablesid.conf',
    ],
    require => Package['pulledpork'],
  }
  file { '/etc/cron.d/pulledpork':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/snort/pulledpork.cron',
    require => File['/etc/pulledpork/disablesid.conf', '/etc/pulledpork/pulledpork.conf'],
  }
#  file { '/etc/snort/rules/VRT.conf':
#    ensure  => present,
#    owner   => root,
#    group   => root,
#    mode    => '0644',
#    source  => [
#      'puppet:///private/snort/VRT.conf',
#      'puppet:///modules/snort/VRT.conf',
#    ],
#    require => File['/etc/cron.d/pulledpork'],
#    notify  => Service['snortd'],
#  }
#  file { '/etc/snort/rules/emerging.conf':
#    ensure  => present,
#    owner   => root,
#    group   => root,
#    mode    => '0644',
#    source  => [
#      'puppet:///private/snort/emerging.conf',
#      'puppet:///modules/snort/emerging.conf',
#    ],
#    require => File['/etc/cron.d/pulledpork'],
#    notify  => Service['snortd'],
#  }
  exec {'pulledporkfetch':
    #command => '/usr/bin/pulledpork.pl -c /etc/pulledpork/pulledpork.conf -o /etc/snort/rules -k -H -v >> /var/log/pulledpork.log',
    command => '/usr/bin/pulledpork.pl -c /etc/pulledpork/pulledpork.conf -H -v >> /var/log/pulledpork.log',
    # creates => '/etc/snort/rules/VRT-backdoor.rules',
    require => File['/etc/pulledpork/disablesid.conf'],
  }
}
