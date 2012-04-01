class CartoonistConfig < ActiveRecord::Base
  class << self
    def [](label)
      raise "Invalid label" unless label.present?
      raise "Missing config definition for '#{label}'" unless Meta[label.to_sym]
      record = where(:label => label.to_s).first

      if record
        Meta[label.to_sym].convert record.value
      else
        Meta[label.to_sym].default
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
      raise "Invalid config type #{@type}" unless [:string, :boolean, :int, :float].include? @type

      if options.include? :default
        @default = options[:default]
      elsif @type == :string
        @default = ""
      elsif @type == :boolean
        @default = false
      elsif @type == :int
        @default = 0
      elsif @type == :float
        @default = 0.0
      end
    end

    def convert(value)
      return default if value.nil?

      case type
      when :string
        value
      when :boolean
        value == "true"
      when :int
        value.to_i
      when :float
        value.to_f
      end
    end

    def convert_to_save(value)
      return value if value.nil?

      if type == :boolean
        (!!value).to_s
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
