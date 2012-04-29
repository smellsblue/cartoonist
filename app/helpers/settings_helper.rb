module SettingsHelper
  def setting_select_value(option)
    if option.kind_of? Hash
      option[:value]
    else
      option
    end
  end

  def setting_select_label(option)
    if option.kind_of? Hash
      t option[:label]
    else
      option
    end
  end
end
