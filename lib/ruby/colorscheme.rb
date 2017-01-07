require 'yaml'

class ColorScheme
  class Color
    attr_reader :hex, :hexr, :hexg, :hexb
    attr_reader :r, :g, :b
    attr_reader :base, :ansi, :bold

    def initialize(colorscheme, hex, base, ansi, bold)
      @colorscheme = colorscheme
      @hex = hex
      (@hexr, @hexg, @hexb) = hex.scan(/../)
      (@r, @g, @b) = hex.scan(/../).map { |color| color.to_i(16) }
      @base = base
      @ansi = ansi
      @bold = bold
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
      ], nil, nil, nil)
    end

    # Add a bit of 'white' to a color.  White is defined by color 7, the end of the
    # gray scale in a color scheme.  (This is usually #FFFFFF, or close.)
    def tint(weight = 50)
      mix(@colorscheme.colors_by_base['07'], weight)
    end

    # Add a bit of 'black' to a color.  White is defined by color 0, the end of the
    # gray scale in a color scheme.  (This is usually #000000, or close.)
    def shade(weight = 50)
      mix(@colorscheme.colors_by_base['00'], weight)
    end

    def x11
      "rgb:#{hexr}/#{hexg}/#{hexb}"
    end

    def rgb
      [r, g, b]
    end
  end

  # Map the base16 code to ansi number based on the number of available
  # colors.  Where approximations had to be made, they were done subjectively
  # by look (https://chriskempson.github.io/base16/) and style guidelines
  # (https://github.com/chriskempson/base16/blob/master/styling.md).
  BASE_TO_ANSI = {
          # 00  01  02  03  04  05  06  07  08  09  0A  0B  0C  0D  0E  0F
    256 => [ 0, 18, 19,  8, 20,  7, 21, 15,  1, 16,  3,  2,  6,  4,  5, 17],
    16  => [ 0,  0,  8,  8,  8,  7, 15, 15,  1,  3,  3,  2,  6,  4,  5,  8],
    8   => [ 0,  0,  0,'0',  7,  7,'7',  7,  1,  3,  3,  2,  6,  4,  5,'0'],
                      # quoted means bold; as in "sorta 0", "sorta 7" ;)
  }

  def initialize
    @scheme_data = YAML.load_file(File.join(Dir.home, '.colorscheme.yaml'))
    @colors = BASE_TO_ANSI.keys.each_with_object(Hash.new) do |term_colors, colors_acc|
      colors_acc[term_colors] = BASE_TO_ANSI[term_colors].each_with_index.map do |ansi, base|
        basestr = '%02X' % base
        hex = @scheme_data["base#{basestr}"]
        bold = ansi.is_a? String
        Color.new(self, hex, basestr, ansi.to_i, bold)
      end
      colors_acc
    end
  end

  def colors(term_colors = 256)
    @colors[term_colors]
  end

  def colors_by_ansi(term_colors = 256)
    @colors[term_colors].sort do |c1, c2|
      if c1.ansi == c2.ansi
        c1.base <=> c2.base
      else
        c1.ansi <=> c2.ansi
      end
    end.each_with_object(Hash.new) do |color, acc|
      acc[color.base] = color
    end
  end

  def colors_by_base(term_colors = 256)
    colors(term_colors).sort_by { |color| color.base }.each_with_object(Hash.new) do |color, acc|
      acc[color.base] = color
    end
  end

  def terminal
    colors_by_ansi(256).values
  end

  def console
    colors_by_ansi(8).values.take(16)
  end

  def foreground
    colors_by_base['05']
  end

  def background
    colors_by_base['00']
  end

  def cursor
    colors_by_base['05']
  end
end
