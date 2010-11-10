
# Contains common methods used by the EemsController and PartsController when uploading content
module ContentUpload
  
  def create_content_dir
    @content_dir = File.join(Sulair::WORKSPACE_DIR, @eem.pid)
    FileUtils.mkdir(@content_dir) unless (File.exists?(@content_dir))
  end
  
  # Assumes params[:content_upload], @content_dir, @log, and @eem, and @user are defined
  def create_part_from_upload_and_log
    content_file = params[:content_upload]
    part = Part.from_params()
    part.add_relationship(:is_part_of, @eem)
    part.save
    
    Rails.logger.debug("Part pid: #{part.pid}")
    
    filename = Part.normalize_filename(content_file.original_filename)
    File.open(File.join(@content_dir,filename), "wb") { |f| f.write(content_file.read) }
    
    part.create_content_datastream(filename)
    part.download_done

    @log.log("File uploaded by #{@user.display_name}")
    @log.save
  end
  
end