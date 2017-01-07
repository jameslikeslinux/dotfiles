require 'yaml'

class ColorScheme
  class Color
    attr_reader :hex, :hexr, :hexg, :hexb
    attr_reader :r, :g, :b

    def initialize(colorscheme, hex)
      @colorscheme = colorscheme
      @hex = hex
      (@hexr, @hexg, @hexb) = hex.scan(/../)
      (@r, @g, @b) = hex.scan(/../).map { |color| color.to_i(16) }
    end

    # Modified from the original base16 builder
    # See: https://github.com/chriskempson/base16-builder/blob/dfe4cbbf7941ee13ddd9890e74e8787e16375dff/base16#L176
    def mix(color, weight = 50)
      p = (weight / 100.0).to_f
      w = p * 2 - 1

      w1 = (w + 1) / 2.0
      w2 = 1 - w1


      Color.new(@colorscheme, "%02x%02x%02x" % [
        (color.r * w1 + r * w2).to_i,
        (color.g * w1 + g * w2).to_i,
        (color.b * w1 + b * w2).to_i,
      ])
    end

    # Add a bit of 'white' to a color.  White is defined by color 7, the end of the
    # gray scale in a color scheme.  (This is usually #FFFFFF, or close.)
    def tint(weight = 50)
      mix(@colorscheme.bases['07'], weight)
    end

    # Add a bit of 'black' to a color.  White is defined by color 0, the end of the
    # gray scale in a color scheme.  (This is usually #000000, or close.)
    def shade(weight = 50)
      mix(@colorscheme.bases['00'], weight)
    end

    def x11
      "rgb:#{hexr}/#{hexg}/#{hexb}"
    end

    def rgb
      [r, g, b]
    end
  end

  BASE_TO_ANSI = {
    256 => ['00', '08', '0B', '0A', '0D', '0E', '0C', '05',
            '03', '08', '0B', '0A', '0D', '0E', '0C', '07',
            '09', '0F', '01', '02', '04', '06'],
    16  => ['00', '08', '0B', '0A', '0D', '0E', '0C', '05',
            '03', '08', '0B', '0A', '0D', '0E', '0C', '07',
            '0A', '08', '00', '00', '05', '07'],
    8   => ['00', '08', '0B', '0A', '0D', '0E', '0C', '05',
            '03', '08', '0B', '0A', '0D', '0E', '0C', '07',
            '0A', '08', '00', '00', '05', '05'],
  }

  attr_reader :bases

  def initialize
    @scheme_data = YAML.load_file(File.join(Dir.home, '.colorscheme.yaml'))
    @bases = (0x0..0xf).each_with_object(Hash.new) do |i, acc|
      code = "%02X" % i
      acc[code] = Color.new(self, @scheme_data["base#{code}"])
      acc
    end
  end

  def base_to_ansi(term_colors = 256)
    canonical_mapping = BASE_TO_ANSI[256]
    bases.keys.each_with_object(Hash.new) do |canonical_code, acc|
      index = canonical_mapping.find_index(canonical_code)
      actual_code = BASE_TO_ANSI[term_colors][index]
      acc[canonical_code] = BASE_TO_ANSI[term_colors].find_index(actual_code) % term_colors
      acc
    end
  end

  def base_to_color(term_colors = 256)
    mapping = Hash.new
    base_to_ansi(term_colors).each do |code, ansi|
      mapping[code] = colors(term_colors)[ansi]
    end
    mapping
  end

  def colors(term_colors = 256)
    BASE_TO_ANSI[term_colors].map { |code| bases[code] }
  end

  def terminal
    colors(256)
  end

  def console
    colors(8).take(16)
  end

  def foreground
    bases['05']
  end

  def background
    bases['00']
  end

  def cursor
    bases['05']
  end
end
