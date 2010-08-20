require 'curl'
require 'tempfile'

ActiveFedora::SolrService.register(SOLR_URL)
Fedora::Repository.register(FEDORA_URL)

module Dor
  class DownloadJob < Struct.new(:content_file_id)
    
    #TODO figure out if it isn't an http GET
    #TODO if job fails, dj retries perform?  Should test if file exists
    def perform
      @cf = ContentFile.find(content_file_id)
      
      @c = Curl::Easy.new(@cf.url)
      @filename = nil
      
      tmpdl = Tempfile.new('dlfile', File.join(RAILS_ROOT,'tmp'))
      File.open(tmpdl.path, "wb") do |output|
        @c.on_header do |hdr|
          if(hdr =~ /content-disposition.*filename\s*=\s*\"?([^\"]*)\"?/i)
            @filename = $1
          end
          Rails.logger.info(hdr)
          hdr.length
        end
        
        @c.on_body do |data|
          output << data
          data.length
        end
        
        @c.on_progress do |dl_total, dl_now, ut, un|
          @cf.update_progress(dl_total, dl_now)
          true
        end
        @c.follow_location = true
        
        @c.perform
      end

      # If filename wasn't sent in the content-disposition header, we assume it is the last part of the url
      unless(@filename)
        @filename = @cf.url.split(/\?/).first.split(/\//).last
      end

      @filename = Part.normalize_filename(@filename)
      
      FileUtils.cp(tmpdl.path, File.join(@cf.filepath,@filename))
      FileUtils.chmod(0644, File.join(@cf.filepath,@filename))
      tmpdl.delete
            
      part = Part.find(@cf.part_pid)
      part.create_content_datastream(@filename)
      part.download_done
      
    rescue Exception => e
      msg = e.message
      unless(e.backtrace.nil?)
        msg << "\n" << e.backtrace.join("\n")
      end
      
      if( @cf.attempts < Delayed::Worker.max_attempts + 1)
        @cf.attempts = @cf.attempts + 1
        @cf.save
      end
      
      Rails.logger.error("DownloadJob Failed: " + msg)
      raise e
    end
    
  end
end
