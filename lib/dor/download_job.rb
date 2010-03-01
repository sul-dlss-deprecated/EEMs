module Dor
  class DownloadJob < Struct.new(:content_file_id)
    
    #TODO figure out if it isn't an http GET
    #TODO what if the filename is different than the last part of the URL path?
    #TODO if job fails, dj retries perform?  Should test if file exists
    def perform
      cf = ContentFile.find(content_file_id)
      Curl::Easy.download(cf.url, cf.filepath) do |curl|
        curl.on_progress do |dl_total, dl_now, ut, un|
          begin
            cf.update_progress(dl_total, dl_now)
          rescue Exception => e
            Rails.logger.error("#{e.to_s}\n\n")
          end
          true
        end
      end
      
      part = Part.find(cf.part_pid)
      part.create_content_datastream
      part.download_done
    end
    
  end
end
