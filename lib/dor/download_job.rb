module Dor
  class DownloadJob < Struct.new(:content_file_id)
    
    #TODO figure out workspace directory
    def perform
      cf = ContentFile.find(content_file_id)
      Curl::Easy.download(cf.url, File.join(RAILS_ROOT, 'tmp', cf.url.split(/\?/).first.split(/\//).last)) do |curl|
        curl.on_progress do |dl_total, dl_now, ut, un|
          begin
            cf.update_progress(dl_total, dl_now)
          rescue Exception => e
            Rails.logger.error("#{e.to_s}\n\n")
          end
          true
        end
      end
    end
    
    
  end
end
