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
        (color.g * w1 + r * w2).to_i,
        (color.b * w1 + r * w2).to_i,
      ])
    end

    # Add a bit of 'white' to a color.  White is defined by color 7, the end of the
    # gray scale in a color scheme.  (This is usually #FFFFFF, or close.)
    def tint(weight = 50)
      mix(@colorscheme.base['07'], weight)
    end

    # Add a bit of 'black' to a color.  White is defined by color 0, the end of the
    # gray scale in a color scheme.  (This is usually #000000, or close.)
    def shade(color, weight = 50)
      mix(@colorscheme.base['00'], weight)
    end

    def x11
      "#{hexr}/#{hexg}/#{hexb}"
    end
  end

  attr_reader :base

  def initialize
    @scheme_data = YAML.load_file(File.join(Dir.home, '.colorscheme.yaml'))
    @base = (0x0..0xf).each_with_object({}) do |i, acc|
      code = "%02X" % i
      acc[code] = Color.new(self, @scheme_data["base#{code}"])
      acc
    end
  end

  def terminal
    ['00', '08', '0B', '0A', '0D', '0E', '0C', '05',
     '03', '08', '0B', '0A', '0D', '0E', '0C', '07',
     '09', '0F', '01', '02', '04', '06'].map { |code| base[code] }
  end

  def foreground
    base['05']
  end

  def background
    base['00']
  end

  def cursor
    base['05']
  end
end
