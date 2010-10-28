class EemsUser

  attr_reader :display_name, :sunetid
  
  def initialize(display_name, sunetid)
    @display_name = display_name
    @sunetid = sunetid
  end
  
end