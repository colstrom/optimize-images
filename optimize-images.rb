#!/usr/bin/env ruby
# Image Optimization Script, by Chris Olstrom <chris@olstrom.com>

dir = ARGV[0] ||= `pwd`.strip # Use a path if one is given, otherwise assume current directory.

optipng = `which optipng`
jpegtran = `which jpegtran`
gifsicle = `which gifsicle`

png = ".png"
jpg = ".jpg"
gif = ".gif"

suffix = "-optimized"
replace_original = false

supported_formats = []
supported_formats.push(png) unless optipng.empty?
supported_formats.push(jpg) unless jpegtran.empty?
supported_formats.push(gif) unless gifsicle.empty?

supported_formats.each do |format|
  p "Optimizing #{format}s in #{dir}"

  case format
  when png
    optimize = [optipng, "PH_FILE", "-out PH_OUTPUT_FILE"]
  when jpg
    optimize = [jpegtran, "-optimize PH_FILE", "-optimize -outfile PH_OUTPUT_FILE PH_FILE"]
  when gif
    optimize = [gifsicle, "--optimize PH_FILE", "--optimize --output=PH_OUTPUT_FILE PH_FILE"]
  end

  Dir.glob(dir + "/**/*#{format}", File::FNM_CASEFOLD).each do |file|
    output_file = "#{File.dirname(file)}/#{File.basename(file,File.extname(file))}#{suffix}#{format}"
    if replace_original
      p "- #{file}"
      `#{optimize[0]} #{optimize[1].sub('PH_FILE', file).sub('PH_OUTPUT_FILE', output_file)}`
    else
      p "- #{file} > #{output_file}"
      `#{optimize[0]} #{optimize[2].sub('PH_FILE', file).sub('PH_OUTPUT_FILE', output_file)}`
    end
  end
end
