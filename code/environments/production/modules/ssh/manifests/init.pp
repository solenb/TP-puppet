class ssh {
        package { 'openssh-server':
                ensure => 'installed',
        }

	case $::osfamily {
 		'Debian': { $sshd_service = 'ssh' }
        	'RedHat': { $sshd_service = 'sshd' }
	 	default: {fail("Invalid osfamily: ${::osfamily}")}
    	}


	service { 'ssh':
    		name => $sshd_service,
        	ensure => running,
        	enable => true,
        	hasstatus => true,
        	hasrestart => true,
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
