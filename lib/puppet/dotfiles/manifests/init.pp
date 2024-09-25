class dotfiles {
  if $facts['profile'] and $facts['profile']['platform'] == 'pinebookpro' {
    file { "${facts['basedir']}/.config/systemd/user/wayland-session.target.wants":
      ensure => directory,
    }

    file { "${facts['basedir']}/.config/systemd/user/wayland-session.target.wants/foot.service":
      ensure => link,
      target => '../foot.service',
    }
  } else {
    file { "${facts['basedir']}/.config/systemd/user/wayland-session.target.wants":
      ensure => absent,
      force  => true,
    }
  }
}
