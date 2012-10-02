Puppet::Type.newtype(:rabbit_user) do 
  desc "The rabbit user provider"

  newparam(:name) do
    desc "rabbitmq username"
  end

  newparam(:password) do 
    desc "rabbitmq password"
  end 

  ensurable

end

