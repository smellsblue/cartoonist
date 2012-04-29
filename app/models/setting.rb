class Setting < ActiveRecord::Base
  attr_accessible :label, :value, :locked

  class << self
    def [](label)
      raise "Invalid label" unless label.present?
      meta = Meta[label.to_sym]
      raise "Missing setting definition for '#{label}'" unless meta

      begin
        record = where(:label => label.to_s).first
      rescue => e
        raise unless e.to_s =~ /Could not find table/
      end

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
      meta = Meta[label.to_sym]
      raise "Missing setting definition for '#{label}'" unless meta
      old_value = self[label]
      record = where(:label => label.to_s).first
      record = Setting.new :label => label.to_s unless record
      record.value = meta.convert_to_save value
      record.save!
      meta.onchange.call if meta.onchange && old_value != value
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
    attr_reader :label, :tab, :section, :order, :type, :default, :onchange, :select_from
    @@settings = {}
    @@by_tab_section_and_label = {}

    def initialize(label, options)
      @label = label.to_sym
      @tab = (options[:tab] || Tab.default)
      @section = (options[:section] || Section.default)
      @order = (options[:order] || 0)
      @type = (options[:type] || :string).to_sym
      @onchange = options[:onchange]
      @select_from = options[:select_from]
      raise "Invalid setting type #{@type}" unless [:string, :symbol, :boolean, :int, :float, :array, :hash].include? @type

      # Auto create general tab and section if it isn't created
      if @tab == :general && !Tab[@tab]
        Tab.define :general, :order => 0
      end

      if @section == :general && !Section.by_tab_and_label[@tab][@section]
        Section.define :general, :order => 0, :tab => @tab
      end

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

    def localized
      I18n.t @label, :scope => "settings.show.settings"
    end

    def select_from_options
      if select_from.respond_to? :call
        select_from.call
      else
        select_from
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
        raise "Missing setting '#{label}'" unless @@settings[label.to_sym]
        @@settings[label.to_sym]
      end

      def []=(label, definition)
        raise "Duplicate setting '#{label}' given!" if @@settings[label.to_sym]
        @@settings[label.to_sym] = definition
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
    @@default = :general

    def initialize(label, options = {})
      @label = label.to_sym
      @order = options[:order] || 1
      Section.by_tab_and_label[@label] ||= {}
    end

    def localized
      I18n.t @label, :scope => "settings.show.tabs"
    end

    def sections
      Section.by_tab_and_label[label] ||= {}
      Section.by_tab_and_label[label].values.sort.map &:label
    end

    def [](section_label)
      Section.by_tab_and_label[label] ||= {}
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

      def default
        @@default
      end

      def with_default_tab(label)
        original = @@default

        begin
          @@default = label.to_sym
          yield
        ensure
          @@default = original
        end
      end

      def define(label, options = {})
        raise "Duplicate tab '#{label}' being defined" if @@by_label.include? label.to_sym
        tab = Tab.new label, options
        @@all << tab
        @@by_label[label.to_sym] = tab

        with_default_tab label do
          yield if block_given?
        end
      end
    end
  end

  class Section
    attr_reader :label, :order, :tab
    @@all = []
    @@by_tab_and_label = {}
    @@default = :general

    def initialize(label, options = {})
      @label = label.to_sym
      @order = options[:order] || 1
      @tab = (options[:tab] || Tab.default).to_sym
    end

    def localized
      I18n.t @label, :scope => "settings.show.sections.#{@tab.label}"
    end

    def settings
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

      def default
        @@default
      end

      def define(label, options = {})
        section = Section.new label, options
        @@all << section
        @@by_tab_and_label[section.tab] ||= {}
        @@by_tab_and_label[section.tab][label.to_sym] = section
        begin
          @@default = label.to_sym

          Tab.with_default_tab section.tab do
            yield if block_given?
          end
        ensure
          @@default = :general
        end
      end

      def by_tab_and_label
        @@by_tab_and_label
      end
    end
  end
end
