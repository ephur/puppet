Puppet::Type.type(:rabbit_user).provide(:rabbitmqctl) do
  desc "puppet vhost provider"

  commands :ctl => "rabbitmqctl"

  def create
    self.class.send_log(:debug, "call create #{@resource[:name]}")
    %x[ rabbitmqctl add_user #{@resource[:name]} #{@resource[:password]} ]
  end

  def destroy
    self.class.send_log(:debug, "call destroy #{@resource[:name]}")
    %x[ rabbitmqctl delete_user #{@resource[:name]} ]
  end

  def exists?
    self.class.send_log(:debug, "call exists? #{@resource[:name]}")
    output = %x[ rabbitmqctl list_users | grep #{resource[:name]} ]
    if output =~ /@resource[:name]/ then
      self.class.send_log(:debug, "#{@resource[:name]} exists")
      return true
    else
      self.class.send_log(:debug, "#{@resource[:name]} does not exist output: #{output}")
      return false
    end

  end
end

