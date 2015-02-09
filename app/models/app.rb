class App < ActiveRecord::Base
	validates :properName, presence: true

  before_save do
    self.downcase = self.properName.downcase
    
    dir = "/home/capptivate/www/videos/#{self.properName}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    
    full_path_to_read = File.expand_path('/home/capptivate/CapptivateHelper/template_hype_generated_script.js')
    full_path_to_write = File.expand_path("/home/capptivate/www/videos/#{self.properName}/#{self.downcase}_hype_generated_script.js")
    File.open(full_path_to_read) { |source_file|
      contents = source_file.read
      contents.gsub!("rep1", self.properName)
      contents.gsub!("rep2", self.downcase)
      contents.gsub!("rep_poster", self.poster_file_name)
      contents.gsub!("rep_movie", self.video_file_name)
      self.js = contents 
      File.open(full_path_to_write, "w+") { |f| f.write(contents) }
    }
    
    full_path_to_read1 = File.expand_path('/home/capptivate/CapptivateHelper/html_template.html')
    full_path_to_write1 = File.expand_path("/home/capptivate/www/videos/#{self.properName}/#{self.properName}.html")
    File.open(full_path_to_read1) { |source_file|
      contents = source_file.read
      contents.gsub!("rep1", self.properName)
      contents.gsub!("rep2", self.downcase)
      File.open(full_path_to_write1, "w+") { |f| f.write(contents) }
    }

    full_path_to_read2 = File.expand_path('/home/capptivate/CapptivateHelper/iframe_template.html')
    File.open(full_path_to_read2) { |source_file|
      contents = source_file.read
      contents.gsub!("rep1", self.properName)
      contents.gsub!("rep2", self.downcase)
      self.html = contents.html_safe
    }

  end
  
  after_save do
    full_path_to_vid = File.expand_path("/home/capptivate/www/videos/#{self.properName}/#{self.video_file_name}")
    full_path_to_png = File.expand_path("/home/capptivate/www/videos/#{self.properName}/#{self.poster_file_name}")

    link_path_to_vid = File.expand_path("/home/capptivate/www/videos/#{self.properName}/video.mov")
    link_path_to_png = File.expand_path("/home/capptivate/www/videos/#{self.properName}/screenshot.png")
    
    File.symlink(full_path_to_vid, link_path_to_vid) unless File.symlink?(link_path_to_vid)
    File.symlink(full_path_to_png, link_path_to_png) unless File.symlink?(link_path_to_png)
    
    theMovie = FFMPEG::Movie.new(full_path_to_vid)
    out = theMovie.transcode("/home/capptivate/www/videos/#{self.properName}/out.mov", "-c:v libx264 -profile:v main -level 4.0 -preset veryfast -crf 22 -an")
    File.rename(full_path_to_vid, "/home/capptivate/www/videos/#{self.properName}/original.mov")
    File.rename("/home/capptivate/www/videos/#{self.properName}/out.mov", full_path_to_vid)
  end

  has_attached_file :video,
    :path => "/home/capptivate/www/videos/:dirName/:basename.:extension"
  validates_attachment :video,
    :content_type => { :content_type => "video/quicktime"},
    :size => { :in => 0..20.megabytes}

  has_attached_file :poster,
    :path => "/home/capptivate/www/videos/:dirName/:basename.:extension"
  validates_attachment :poster,
    :content_type => { :content_type => "image/png"},
    :size => { :in => 0..2.megabytes}

end
