
module SULAIR
  WORKSPACE_DIR = File.join(RAILS_ROOT, 'workspace')
  
end

unless(File.exists?(SULAIR::WORKSPACE_DIR))
  FileUtils.mkdir(SULAIR::WORKSPACE_DIR)
  FileUtils.ln_s(SULAIR::WORKSPACE_DIR, File.join(RAILS_ROOT, 'public', 'workspace'))
end