class dotfiles {
  $urxvtd_ensure = $facts['profile']['platform'] ? {
    'pinebookpro' => absent,
    default       => absent,
  }

  file { "${facts['basedir']}/.config/systemd/user/x-session.target.wants/urxvtd.service":
    ensure => $urxvtd_ensure,
    target => '../urxvtd.service',
  }
}
