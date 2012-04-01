class CartoonistConfig < ActiveRecord::Base
  class << self
    def [](label)
      raise "Invalid label" unless label.present?
      meta = Meta[label.to_sym]
      raise "Missing config definition for '#{label}'" unless meta
      record = where(:label => label.to_s).first

      if record
        meta.convert record.value
      elsif meta.type == :array || meta.type == :hash
        meta.default.dup
      else
        meta.default
      end
    end

    def []=(label, value)
      raise "Invalid label" unless label.present?
      raise "Missing config definition for '#{label}'" unless Meta[label.to_sym]
      record = where(:label => label.to_s).first
      record = CartoonistConfig.new :label => label.to_s unless record
      record.value = Meta[label.to_sym].convert_to_save value
      record.save!
      value
    end

    def define(label, options = {})
      Meta[label] = Meta.new label, options
    end
  end

  class Meta
    attr_reader :label, :type, :default
    @@configs = {}

    def initialize(label, options)
      @label = label.to_sym
      @type = (options[:type] || :string).to_sym
      raise "Invalid config type #{@type}" unless [:string, :symbol, :boolean, :int, :float, :array, :hash].include? @type

      if options.include? :default
        @default = options[:default]
      elsif @type == :string
        @default = ""
      elsif @type == :symbol
        @default = :""
      elsif @type == :boolean
        @default = false
      elsif @type == :int
        @default = 0
      elsif @type == :float
        @default = 0.0
      elsif @type == :array
        @default = []
      elsif @type == :hash
        @default = {}
      end
    end

    def convert(value)
      if value.nil?
        return default.dup if type == :array || type == :hash
        return default
      end

      case type
      when :string
        value
      when :symbol
        value.to_sym
      when :boolean
        value == "true"
      when :int
        value.to_i
      when :float
        value.to_f
      when :array
        YAML.load value
      when :hash
        YAML.load value
      end
    end

    def convert_to_save(value)
      return value if value.nil?

      if type == :boolean
        (!!value).to_s
      elsif type == :array || type == :hash
        value.to_yaml
      else
        value.to_s
      end
    end

    class << self
      def [](label)
        raise "Missing config '#{label}'" unless @@configs[label.to_sym]
        @@configs[label.to_sym]
      end

      def []=(label, definition)
        raise "Duplicate configuration '#{label}' given!" if @@configs[label.to_sym]
        @@configs[label.to_sym] = definition
      end
    end
  end
end
