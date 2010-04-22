require 'yaml'

class EemsUser
  @@all_users = nil
  
  attr_reader :first_name, :last_name, :sunetid
  
  def initialize(fname, lname, sunetid)
    @first_name = fname
    @last_name = lname
    @sunetid = sunetid
  end
  
  def display_name
    @first_name + ' ' + @last_name
  end
  
  def display_name_lf
    @last_name + ', ' + @first_name
  end
    
  def EemsUser.find(sunetid)
    load_config
    
    u = @@all_users[sunetid]
    return EemsUser.new(u['first_name'], u['last_name'], sunetid) if(u)
    nil
  end
  
  def EemsUser.valid?(sunetid)
    load_config
    
    return @@all_users.member?(sunetid)
  end
  
  protected
  def EemsUser.load_config
    unless(@@all_users)
      @@all_users = YAML::load_file(File.join(RAILS_ROOT, "config", "users.yml"))
    end
  end
end