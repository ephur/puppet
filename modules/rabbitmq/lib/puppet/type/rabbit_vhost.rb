Puppet::Type.newtype(:rabbit_vhost) do 
  desc "The rabbit vhost provider"

  newparam(:name) do
    desc "Virtual host name"
  end

  ensurable

end

