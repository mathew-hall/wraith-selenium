require 'erb'
require 'pp'
require 'fileutils'
require 'wraith/wraith'

class Wraith::GalleryGenerator
  attr_reader :wraith

  MATCH_FILENAME = /(\S+)_(\S*)_(\S+)_(\S+)_(\S+)_(\S+)_(\S*)_(\S*)\.\S+/
  TEMPLATE_LOCATION = File.expand_path('gallery_template/gallery_template.erb', File.dirname(__FILE__))
  TEMPLATE_BY_DOMAIN_LOCATION = File.expand_path('gallery_template/gallery_template.erb', File.dirname(__FILE__))
  BOOTSTRAP_LOCATION = File.expand_path('gallery_template/bootstrap.min.css', File.dirname(__FILE__))

  def initialize(config)
    @wraith = Wraith::Wraith.new(config)
    @location = wraith.directory
  end

  def parse_directories(dirname)
    @dirs = {}
    categories = Dir.foreach(dirname).select do |category|
      if ['.', '..', 'thumbnails'].include? category
        # Ignore special dirs
        false
      elsif File.directory? "#{dirname}/#{category}" then
        # Ignore stray files
        true
      else
        false
      end
    end
    match(categories, dirname)
  end

  def match(categories, dirname)
    categories.each do |category|
      @dirs[category] = {}
      @diff_data
      Dir.foreach("#{dirname}/#{category}") do |filename|
        match = MATCH_FILENAME.match(filename)
        if !match.nil?
          size = match[1].to_i
          engine = match[2]
          run_mode = match[3]
          platform_type = match[4]
          platform = match[5]
          browser = match[6]
          version = match[7]
          screenshot_type = match[8]
          filepath = category + "/" + filename
          thumbnail = "thumbnails/#{category}/#{filename}"

          unless !@dirs[category][size].nil?
            @dirs[category][size] = { variants: [] }
          end
          size_dict = @dirs[category][size]

          case screenshot_type
          # when 'diff'
          #   size_dict[:diff] = {
          #       filename: filepath, thumb: thumbnail
          #   }
          when 'data'
            size_dict[:data] = File.read("#{dirname}/#{filepath}")
            @diff_data = File.read("#{dirname}/#{filepath}")
          else
            size_dict[:variants] << {
                screenshot_type: screenshot_type,
                engine: engine,
                run_mode: run_mode,
                platform_type: platform_type,
                platform: platform,
                browser: browser,
                version: version,
                filename: filepath,
                thumb: thumbnail,
                diff_data: @diff_data
              }

          end
          size_dict[:variants].sort! { |a, b| a[:name] <=> b[:name] }
        end
      end
    end
   @dirs
  end

  def generate_html(location, directories, template, destination, path)
    template = File.read(template)
    locals = {
        location: location,
        directories: directories,
        path: path
    }
    html = ERB.new(template).result(ErbBinding.new(locals).get_binding)
    File.open(destination, 'w') do |outf|
      outf.write(html)
    end
  end

  def generate_gallery(withPath="")
    dest = "#{@location}/gallery.html"
    directories = parse_directories(@location)
    generate_html(@location, directories, TEMPLATE_BY_DOMAIN_LOCATION, dest, withPath)
    FileUtils.cp(BOOTSTRAP_LOCATION, "#{@location}/bootstrap.min.css")
  end

  class ErbBinding < OpenStruct
    def get_binding
      binding
    end
  end
end
