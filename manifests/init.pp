#
# = Class: snort
#
# This module manages snort package
#
class snort (
  $snort_conf_template   = 'snort/snort.conf.erb',
  $threshold_conf_source = 'puppet:///modules/snort/threshold.conf',
  $local_conf_source     = 'puppet:///modules/snort/local.conf',
  $local_rules_source    = 'puppet:///modules/snort/local.rules',
  $snortd_initrc_source  = 'puppet:///modules/snort/snortd',
  $logdir                = $::snort::params::logdir,
  $interfaces            = $::snort::params::interfaces,
  $home_net              = $::snort::params::home_net,
  $dns_servers           = $::snort::params::dns_servers,
  $smtp_servers          = $::snort::params::smtp_servers,
  $http_servers          = $::snort::params::http_servers,
  $sql_servers           = $::snort::params::sql_servers,
  $ftp_servers           = $::snort::params::ftp_servers,
  $telnet_servers        = $::snort::params::telnet_servers,
  $oinkcode              = $::snort::params::oinkcode,
  $snortrules_snapshot   = $::snort::params::snortrules_snapshot,
  $ppork_ignore          = $::snort::params::ppork_ignore,
) inherits snort::params {

  package { 'snort':
    ensure  => present,
  }

  File {
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['snort'],
    notify  => Service['snortd'],
  }

  file { '/etc/snort/snort.conf':
    content => template($snort_conf_template),
  }

  file { '/etc/snort/threshold.conf':
    source => $threshold_conf_path,
  }

  file { '/etc/sysconfig/snort':
    content => template('snort/snort.sysconfig.erb'),
  }

  file { '/etc/snort/local.conf':
    source  => $local_conf_source,
    require => File['/etc/snort/snort.conf'],
  }

  file { '/etc/snort/rules/local.rules':
    source  => $local_rules_source,
    require => File['/etc/snort/local.conf'],
  }

  file { '/var/log/snort':
    ensure  => directory,
    path    => $logdir,
    owner   => 'snortd',
    group   => 'snortd',
    mode    => '0750',
  }

  file { '/etc/init.d/snortd':
    mode   => '0755',
    source => $snortd_initrc_source,
  }

  service { 'snortd':
    ensure  => running,
    enable  => true,
    require => File[$logdir, '/etc/snort/rules/local.rules', '/etc/init.d/snortd' ],
  }

}
