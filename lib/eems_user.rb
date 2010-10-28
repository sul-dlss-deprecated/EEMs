class EemsUser

  attr_reader :display_name, :sunetid
  
  def initialize(display_name, sunetid)
    @display_name = display_name
    @sunetid = sunetid
  end
  
  def save_to_session(session)
    u = {:display_name => @display_name, :sunetid => @sunetid}
    session[:eems_user] = u
  end
  
  # TODO what to do when there is no :eems_user in the session
  def EemsUser.load_from_session(session)
    u = EemsUser.new(session[:eems_user][:display_name], session[:eems_user][:sunetid])
    u
  end
  
  def EemsUser.user_webauthed?(session)
    return true unless(session[:eems_user].nil?)
    false
  end
  
end