require 'wraith'
require 'image_size'

class Wraith::CropImages
  attr_reader :wraith

  def initialize(config)
    @wraith = Wraith::Wraith.new(config)
  end

  def crop
    crop_value(base_height, compare_height, @compare, @base)
  end

  def height
    crop_value(base_height, compare_height, base_height, compare_height)
  end

  def base_height
    @wraith.find_image_dimensions(@base,'height')
  end

  def compare_height
    @wraith.find_image_dimensions(@compare,'height')
  end

  def crop_images
    files = Dir.glob("#{wraith.directory}/*/*.png").sort
    until files.empty?
      #TODO - REFACTOR THIS INTO ONE ROUTINE - PROB IN WRAITH
      base, files = @wraith.get_files_from_array_while_regex(files,@wraith.base_domain_label,@wraith.comp_domain_label)
      compare, files = @wraith.get_files_from_array_while_regex(files,@wraith.comp_domain_label,@wraith.base_domain_label)
      #in fact should only be base file at a time
      base.each do |base_shot|
        @base = base_shot
        #can be multiple compare files if using browser based comparison
        compare.each do |compare_shot|
          @compare = compare_shot
          puts 'cropping images'
          Wraith::Wraith.crop_images(crop, height)
        end
      end
    end
  end

  def crop_value(base_height, compare_height, arg3, arg4)
    if base_height > compare_height
      arg4
    else
      arg3
    end
  end


end
