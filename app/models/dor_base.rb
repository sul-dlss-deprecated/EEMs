
# TODO move to lyber_core?
module DorBase

  def setup(attrs = {})
    unless attrs[:pid]
      attrs = attrs.merge!({:pid=>Services::SuriService.mint_id})  
      @new_object=true
    else
      @new_object = attrs[:new_object] == false ? false : true
    end
    @inner_object = Fedora::FedoraObject.new(attrs)
    @datastreams = {}
    configure_defined_datastreams
  end  

end