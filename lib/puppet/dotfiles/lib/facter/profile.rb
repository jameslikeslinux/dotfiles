Facter.add('profile') do
  confine osfamily: 'Gentoo'
  setcode do
    arch = Facter::Core::Execution.execute('/usr/bin/portageq envvar ARCH')
    profile = Facter::Core::Execution.execute('/usr/bin/eselect --brief profile show')
    case profile
    when %r{nest:(\S+)/(\S+)/(\S+)}
      { architecture: arch, cpu: Regexp.last_match(1), platform: Regexp.last_match(2), role: Regexp.last_match(3) }
    when %r{nest:(\S+)/(\S+)}
      { architecture: arch, cpu: Regexp.last_match(1), platform: Regexp.last_match(1), role: Regexp.last_match(2) }
    end
  end
end
