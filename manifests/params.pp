# Class: snort::params
#
#   The snort configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class snort::params {
  $logdir         = '/var/log/snort'
  $interfaces     = 'eth0'
  $home_net       = '127.0.0.0/8'
  $dns_servers    = '8.8.8.8,8.8.4.4'
  $smtp_servers   = '127.0.0.1'
  $http_servers   = '127.0.0.1'
  $sql_servers    = '127.0.0.1'
  $ftp_servers    = '127.0.0.1'
  $telnet_servers = '127.0.0.1'
  $oinkcode       = 'getyourwonOINKcode'
  $ppork_ignore   = 'deleted.rules,experimental.rules,local.rules'
}
