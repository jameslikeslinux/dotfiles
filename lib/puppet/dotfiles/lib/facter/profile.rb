Facter.add('profile') do
  confine :osfamily => 'Gentoo'
  setcode do
    profile = Facter::Core::Execution.execute('/usr/bin/eselect --brief profile show')
    case profile
    when %r{nest:(\S+)/(\S+)/(\S+)}
      { :cpu => $1, :platform => $2, :role => $3 }
    when %r{nest:(\S+)/(\S+)}
      { :cpu => $1, :platform => $1, :role => $2 }
    end
  end
end

Facter.add('profile') do
  confine :osfamily => 'windows'
  setcode do
    { :role => 'workstation' }
  end
end
