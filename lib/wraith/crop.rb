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
      base, files = @wraith.get_files_on_regex(files,@wraith.base_domain_label,@wraith.comp_domain_label)
      compare, files = @wraith.get_files_on_regex(files,@wraith.comp_domain_label,@wraith.base_domain_label)
      #in fact should only be base file at a time
      base.each do |base_shot|
        @base = base_shot
        base_height = @wraith.find_image_dimensions(@base,'height')
        #can be multiple compare files if using browser based comparison
        compare.each do |compare_shot|
          @compare = compare_shot
          compare_height = @wraith.find_image_dimensions(@compare,'height')
          if base_height != compare_height
            file_to_crop = crop
            file_height_to_crop_to = base_height > compare_height ? compare_height : base_height
            output = @wraith.create_cropped_file_path(file_to_crop,height)
            puts 'cropping image to ' + output
            Wraith::Wraith.crop_images(file_to_crop, file_height_to_crop_to, output)
          end
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
