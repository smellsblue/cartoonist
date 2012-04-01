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
      Meta[label.to_sym] = Meta.new label, options
    end

    def tabs
      Tab.all.sort.map &:label
    end
  end

  class Meta
    attr_reader :label, :tab, :section, :order, :type, :default
    @@configs = {}
    @@by_tab_section_and_label = {}

    def initialize(label, options)
      @label = label.to_sym
      @tab = (options[:tab] || :general)
      @section = (options[:section] || :general)
      @order = (options[:order] || 0)
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

    def <=>(other)
      result = order <=> other.order
      result = label <=> other.label if result == 0
      result
    end

    class << self
      def [](label)
        raise "Missing config '#{label}'" unless @@configs[label.to_sym]
        @@configs[label.to_sym]
      end

      def []=(label, definition)
        raise "Duplicate configuration '#{label}' given!" if @@configs[label.to_sym]
        @@configs[label.to_sym] = definition
        @@by_tab_section_and_label[definition.tab] ||= {}
        @@by_tab_section_and_label[definition.tab][definition.section] ||= {}
        @@by_tab_section_and_label[definition.tab][definition.section][label.to_sym] = definition
      end

      def by_tab_section_and_label
        @@by_tab_section_and_label
      end
    end
  end

  class Tab
    attr_reader :label, :order
    @@all = []
    @@by_label = {}

    def initialize(label, options = {})
      @label = label.to_sym
      @order = options[:order] || 1
    end

    def sections
      Section.by_tab_and_label[label].values.sort.map &:label
    end

    def [](section_label)
      Section.by_tab_and_label[label][section_label.to_sym]
    end

    def <=>(other)
      result = order <=> other.order
      result = label <=> other.label if result == 0
      result
    end

    class << self
      def [](label)
        @@by_label[label.to_sym]
      end

      def all
        @@all
      end

      def define(label, options = {})
        raise "Duplicate tab '#{label}' being defined" if @@by_label.include? label.to_sym
        tab = Tab.new label, options
        @@all << tab
        @@by_label[label.to_sym] = tab
      end
    end
  end

  class Section
    attr_reader :label, :order, :tab
    @@all = []
    @@by_tab_and_label = {}

    def initialize(label, options = {})
      @label = label.to_sym
      @order = options[:order] || 1
      @tab = (options[:tab] || :general).to_sym
    end

    def configs
      Meta.by_tab_section_and_label[tab][label].values.sort.map &:label
    end

    def <=>(other)
      result = order <=> other.order
      result = label <=> other.label if result == 0
      result
    end

    class << self
      def all
        @@all
      end

      def define(label, options = {})
        section = Section.new label, options
        @@all << section
        @@by_tab_and_label[section.tab] ||= {}
        @@by_tab_and_label[section.tab][label.to_sym] = section
      end

      def by_tab_and_label
        @@by_tab_and_label
      end
    end
  end

  Tab.define :general, :order => 0
  Section.define :general, :order => 0, :tab => :general
end