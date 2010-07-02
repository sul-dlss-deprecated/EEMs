require 'curl'
require 'tempfile'

ActiveFedora::SolrService.register(SOLR_URL)
Fedora::Repository.register(FEDORA_URL)

module Dor
  class DownloadJob < Struct.new(:content_file_id)
    
    #TODO figure out if it isn't an http GET
    #TODO what if the filename is different than the last part of the URL path?
    #TODO if job fails, dj retries perform?  Should test if file exists
    def perform
      cf = ContentFile.find(content_file_id)
      
      @c = Curl::Easy.new(cf.url)
      @filename = nil
      
      tmpdl = Tempfile.new('dlfile', File.join(RAILS_ROOT,'tmp'))
      File.open(tmpdl.path, "wb") do |output|
        @c.on_header do |hdr|
          @filename = $1 if(hdr =~ /content-disposition.*filename=\"?([^\"]*)\"?/i)
          hdr.length
        end
        
        @c.on_body do |data|
          output << data
          data.length
        end
        
        @c.on_progress do |dl_total, dl_now, ut, un|
          begin
            cf.update_progress(dl_total, dl_now)
          rescue Exception => e
            Rails.logger.error("#{e.to_s}\n\n")
          end
          true
        end
        @c.follow_location = true
        
        @c.perform
      end

      # If filename wasn't sent in the content-disposition header, we assume it is the last part of the url
      unless(@filename)
        @filename = cf.url.split(/\?/).first.split(/\//).last
      end

      FileUtils.cp(tmpdl.path, File.join(cf.filepath,@filename))
      tmpdl.delete
            
      part = Part.find(cf.part_pid)
      part.create_content_datastream(@filename)
      part.download_done
    rescue Exception => e
      msg = e.message
      unless(e.backtrace.nil?)
        msg << "\n\n" << e.backtrace.join("\n")
      end
      Rails.logger.error("DownloadJob Failed: " + msg)
      raise e
    end
    
  end
end
