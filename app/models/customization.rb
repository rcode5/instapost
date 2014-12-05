class Customization < ActiveRecord::Base

  COLORS = { 
    pink:'rgba(255,200,200, 0.3)',
    lavender: 'rgba(240, 200, 240, 0.3)',
    green: 'rgba(200,255,200, 0.3)',
    blue: 'rgba(200,200,255, 0.3)',
    yellow: 'rgba(255,255,200, 0.3)',
    orange: 'rgba(255, 230, 200, 0.3)'
  }
  
  FONTS = [:raleway, :courier, :helvetica]

  def self.current
    order(created_at: :desc).first
  end

  def color_value
    COLORS[color.to_sym]
  end

  def self.color_select_options
    COLORS.keys.map{|k| [k.to_s.humanize,k] }
  end

  def self.font_select_options
    FONTS.map{|k| [k.to_s.humanize,k] }
  end
end
