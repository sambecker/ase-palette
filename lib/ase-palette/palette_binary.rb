module ASEPalette
  module PaletteBinary
    DEFAULT_VERSION_MAJOR   = 1
    DEFAULT_VERSION_MINOR   = 0

    BLOCK_TYPE_COLOR        = 0x1
    BLOCK_TYPE_GROUP_START  = 0xC001
    BLOCK_TYPE_GROUP_END    = 0xC002
    
    COLOR_TYPE_GLOBAL       = 0
    COLOR_TYPE_SPOT         = 1
    COLOR_TYPE_NORMAL       = 2
    COLOR_TYPE_DEFAULT      = COLOR_TYPE_NORMAL

    COLOR_MODEL_RGB         = "RGB "
    COLOR_MODEL_CMYK        = "CMYK"
    COLOR_MODEL_LAB         = "LAB "
    COLOR_MODEL_GRAY        = "GRAY"
    COLOR_MODEL_DEFAULT     = COLOR_MODEL_RGB

    class ASEBinData < BinData::Record
      endian :big

      class String16Null < BinData::Primitive
        endian :big

        uint16 :len, value: -> { data.length / 2 + 1 }
        string :data, read_length: -> { (len - 1) * 2 }
        uint16 :null_terminator, value: 0

        # Force UTF-16 string encoding when anonymous bytes are read in,
        # then encode for UTF-8 when user requests the string
        def get
          self.data.force_encoding(Encoding::UTF_16BE).encode(Encoding::UTF_8)
        end

        # Expect a UTF-8 string when setting
        def set(string)
          self.data = string.encode(Encoding::UTF_16BE)
        end

        # Calculate size, in bytes, of
        # UTF-16-encoded string and
        # null terminator
        def size
          self.data.length + 2
        end
      end
    
      string :signature, value: "ASEF", read_length: 4
      uint16 :version_major, initial_value: DEFAULT_VERSION_MAJOR
      uint16 :version_minor, initial_value: DEFAULT_VERSION_MINOR
      uint32 :block_count, value: -> { blocks.length }
    
      array :blocks, initial_length: -> { block_count } do
        uint16 :block_type

        uint32 :block_length, value: -> {
          block_length = 0
          if block_type == BLOCK_TYPE_COLOR ||
            block_type == BLOCK_TYPE_GROUP_START
            block_length += block_data.name.size
          end
          if block_type == BLOCK_TYPE_COLOR
            block_length += 8
            case block_data.color_model
            when COLOR_MODEL_RGB
              block_length += 4 * 3
            when COLOR_MODEL_CMYK, COLOR_MODEL_GRAY
              block_length += 4 * 4
            when COLOR_MODEL_LAB
              block_length += 4 * 3
            end
          elsif block_type == BLOCK_TYPE_GROUP_START
            block_length += 2
          end
          block_length
        }

        choice :block_data, selection: -> { block_type } do
          class BlockGroupStart < BinData::Record
            endian :big
            String16Null :name
          end
          class BlockGroupEnd < BinData::Record
          end
          class BlockColor < BinData::Record
            endian :big
            String16Null :name
            string :color_model, read_length: 4
            choice :color_data, selection: -> { color_model } do
              class ColorDataRGB < BinData::Record
                endian :big
                float :red, initial_value: 0
                float :green, initial_value: 0
                float :blue, initial_value: 0
              end
              class ColorDataCMYK < BinData::Record
                endian :big
                float :cyan, initial_value: 0
                float :magenta, initial_value: 0
                float :yellow, initial_value: 0
                float :black, initial_value: 0
              end
              class ColorDataLAB < BinData::Record
                endian :big
                float :lightness, initial_value: 0
                float :a, initial_value: 0
                float :b, initial_value: 0
              end
    
              ColorDataRGB  COLOR_MODEL_RGB
              ColorDataCMYK COLOR_MODEL_CMYK
              ColorDataLAB  COLOR_MODEL_LAB
              # Grayscale data is stored in a CMYK structure
              ColorDataCMYK COLOR_MODEL_GRAY
            end
            uint16 :color_type, initial_value: COLOR_TYPE_DEFAULT
          end
          BlockGroupStart  BLOCK_TYPE_GROUP_START
          BlockGroupEnd    BLOCK_TYPE_GROUP_END
          BlockColor       BLOCK_TYPE_COLOR
        end
      end
    end

    def self.build_binary_palette(
      colors,
      groups,
      version_major = DEFAULT_VERSION_MAJOR,
      version_minor = DEFAULT_VERSION_MINOR
    )
      palette = ASEBinData.new
      palette.version_major = version_major
      palette.version_minor = version_minor
      colors.each do |color|
        binary_add_color(
          palette,
          color[:name],
          color[:model],
          color[:type],
          color[:data],
        )
      end
      groups.each do |group|
        binary_begin_group(palette, group[:name])
        group[:colors].each do |color|
          binary_add_color(
            palette,
            color[:name],
            color[:model],
            color[:type],
            color[:data],
          )
        end
        binary_end_group(palette)
      end
      palette
    end

    def self.build_binary_hash_from_file(path)
      file = File.open(path)
      binary = ASEBinData.read(file)
      binary_to_hash(binary)
    end

    private

    def self.binary_add_color(palette, name, model, type, data)
      case model
      when :rgb
        color_model = COLOR_MODEL_RGB
        color_data = {
          red: data[:r] / 255.0,
          green: data[:g] / 255.0,
          blue: data[:b] / 255.0,
        }
      when :cmyk
        color_model = COLOR_MODEL_CMYK
        color_data = {
          cyan: data[:c] / 100.0,
          magenta: data[:m] / 100.0,
          yellow: data[:y] / 100.0,
          black: data[:k] / 100.0,
        }
      when :lab
        color_model = COLOR_MODEL_LAB
        color_data = {
          lightness: data[:l] / 100.0,
          a: data[:a],
          b: data[:b],
        }
      when :gray
        # Grayscale is no longer supported by Adobe (was it ever?)
        # This will default to a CMYK value with data only for black
        color_model = COLOR_MODEL_CMYK
        color_data = {
          cyan: 0.0,
          magenta: 0.0,
          yellow: 0.0,
          black: data[:gray] / 100.0,
        }
      end

      case type
      when :global
        color_type = COLOR_TYPE_GLOBAL
      when :spot
        color_type = COLOR_TYPE_SPOT
      when :normal
        color_type = COLOR_TYPE_NORMAL
      end

      palette.blocks.push({
        block_type: BLOCK_TYPE_COLOR,
        block_data: {
          name: name,
          color_model: color_model,
          color_data: color_data,
          color_type: color_type,
        }
      })
    end

    def self.binary_begin_group(palette, name)
      palette.blocks.push({
        block_type: BLOCK_TYPE_GROUP_START,
        block_data: {
          name: name
        }
      })
    end

    def self.binary_end_group(palette)
      palette.blocks.push({
        block_type: BLOCK_TYPE_GROUP_END,
      })
    end

    def self.binary_to_hash(binary)
      palette = {
        version_major: binary.version_major,
        version_minor: binary.version_minor,
        colors: [],
        groups: [],
      }

      current_group = nil
      binary.blocks.each do |block|
        block_type = block[:block_type]
        block_data = block[:block_data]
        if block_type == BLOCK_TYPE_COLOR || block_type == BLOCK_TYPE_GROUP_START
          block_name = block_data[:name]
        end
        if block_type == BLOCK_TYPE_COLOR
          color = { name: block_name }

          color_data = block_data[:color_data]

          case block_data[:color_model]
          when COLOR_MODEL_RGB
            color[:model] = :rgb
            color[:data] = {
              r: (color_data[:red] * 255.0).round,
              g: (color_data[:green] * 255.0).round,
              b: (color_data[:blue] * 255.0).round,
            }
          when COLOR_MODEL_CMYK, COLOR_MODEL_GRAY
            color[:model] = :cmyk
            color[:data] = {
              c: (color_data[:cyan] * 100.0).round,
              m: (color_data[:magenta] * 100.0).round,
              y: (color_data[:yellow] * 100.0).round,
              k: (color_data[:black] * 100.0).round,
            }
          when COLOR_MODEL_LAB
            color[:model] = :lab
            color[:data] = {
              l: (color_data[:lightness] * 100.0).round,
              a: (color_data[:a]).round,
              b: (color_data[:b]).round,
            }
          end

          case block_data[:color_type]
          when COLOR_TYPE_GLOBAL
            color[:type] = :global
          when COLOR_TYPE_SPOT
            color[:type] = :spot
          when COLOR_TYPE_NORMAL
            color[:type] = :normal
          end

          if current_group
            current_group[:colors] << color
          else
            palette[:colors] << color
          end
        elsif block_type == BLOCK_TYPE_GROUP_START
          current_group = {
            name: block_name,
            colors: []
          }
          palette[:groups] << current_group
        elsif block_type == BLOCK_TYPE_GROUP_END
          current_group = nil
        end
      end

      palette
    end
  end
end
