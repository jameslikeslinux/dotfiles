class dotfiles {
  if $facts['profile'] and $facts['profile']['platform'] == 'pinebookpro' {
    file { "${facts['basedir']}/.config/systemd/user/x-session.target.wants/urxvtd.service":
      ensure => absent,
    }
  } else {
    file { "${facts['basedir']}/.config/systemd/user/x-session.target.wants/urxvtd.service":
      ensure => link,
      target => '../urxvtd.service',
    }
  }
}
