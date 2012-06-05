class SimpleTemplate
  class << self
    def [](str, variables = {})
      return "" if str.nil?
      variables ||= {}

      str.gsub /\{\{([^\}]*)\}\}/ do |matched|
        key = $1.strip.to_sym

        if variables.include? key
          value = variables[key]
          value = value.call if value.respond_to? :call
          value
        elsif variables.include?(:self) && variables[:self].respond_to?(key)
          variables[:self].send key
        else
          ""
        end
      end
    end
  end
end
