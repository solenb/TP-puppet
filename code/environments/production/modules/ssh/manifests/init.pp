class ssh {
        package { 'openssh-server':
                ensure => 'installed',
        }
$os = $facts['os']['family'] ? {
  'RedHat' 		=> 'sshd',
  /(Debian|Ubuntu)/ 	=> 'ssh',
  default               => 'root',
}

service { '$os':
    ensure  => 'running',
    enable  => true,
    require => Package['openssh-server'],
	}
file { '/etc/ssh/sshd_config':
    notify  => Service['$os'],
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    require => Package['openssh-server'],
    content  => 'template("ssh/sshd_config.erb")',
  }

}
