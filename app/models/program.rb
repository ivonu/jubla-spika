class Program < ActiveRecord::Base
  before_destroy :destroy_entries

  has_many :program_entries, dependent: :destroy
  has_many :entries, through: :program_entries
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :delete_user, :class_name => 'User', :foreign_key => 'delete_user'

  validates :title, presence: true


  filterrific(
    default_filter_params: {
      sorted_by: 'rating_desc'
    },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_part_start,
      :with_part_main,
      :with_part_end,
      :only_programs,
      :with_indoors,
      :with_outdoors,
      :with_weather_snow,
      :with_weather_rain,
      :with_weather_sun,
      :with_act_active,
      :with_act_calm,
      :with_act_creative,
      :with_cat_pocket, 
      :with_cat_craft,
      :with_cat_cook,
      :with_cat_pioneer,
      :with_cat_night,
      :num_group_min,
      :num_group_max,
      :num_age_min,
      :num_age_max,
      :num_time_min,
      :num_time_max
    ]
  )

  def self.check_boolean_attr attr_name, attr_value
    return nil  if 0 == attr_value
    where(attr_name.to_sym => true)
  end

  scope :only_programs, lambda { |flag| }
  scope :with_part_start, lambda { |flag| }
  scope :with_part_main, lambda { |flag| }
  scope :with_part_end, lambda { |flag| }
  scope :with_indoors, lambda { |flag| check_boolean_attr "indoors", flag }
  scope :with_outdoors, lambda { |flag| check_boolean_attr "outdoors", flag }
  scope :with_weather_snow, lambda { |flag| check_boolean_attr "weather_snow", flag }
  scope :with_weather_rain, lambda { |flag| check_boolean_attr "weather_rain", flag }
  scope :with_weather_sun, lambda { |flag| check_boolean_attr "weather_sun", flag }
  scope :with_act_active, lambda { |flag| check_boolean_attr "act_active", flag }
  scope :with_act_calm, lambda { |flag| check_boolean_attr "act_calm", flag }
  scope :with_act_creative, lambda { |flag| check_boolean_attr "act_creative", flag }
  scope :with_cat_pocket, lambda { |flag| check_boolean_attr "cat_pocket", flag }
  scope :with_cat_craft, lambda { |flag| check_boolean_attr "cat_craft", flag }
  scope :with_cat_cook, lambda { |flag| check_boolean_attr "cat_cook", flag }
  scope :with_cat_pioneer, lambda { |flag| check_boolean_attr "cat_pioneer", flag }
  scope :with_cat_night, lambda { |flag| check_boolean_attr "cat_night", flag }

  def self.check_integer_attr attr_name, attr_value, comp
    return nil  if attr_value.blank?
    return nil  if !attr_value.is_a? Integer
    where("#{attr_name} #{comp} #{attr_value.to_s}")
  end

  scope :num_group_min, lambda { |num| check_integer_attr "group_size_min", num, "<="}
  scope :num_group_max, lambda { |num| check_integer_attr "group_size_max", num, ">="}
  scope :num_age_min, lambda { |num| check_integer_attr "age_min", num, "<="}
  scope :num_age_max, lambda { |num| check_integer_attr "age_max", num, ">="}
  scope :num_time_min, lambda { |num| check_integer_attr "time_min", num, "<="}
  scope :num_time_max, lambda { |num| check_integer_attr "time_max", num, ">="}

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    where(
      "(LOWER(programs.title) LIKE :q
      OR LOWER(programs.search_text) LIKE :q
      OR LOWER(programs.material) LIKE :q
      OR LOWER(programs.remarks) LIKE :q
      OR LOWER(programs.preparation) LIKE :q)",
      :q => "%#{query}%"
    )
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'

    case sort_option.to_s
    when /^rating_/
      order("programs.rating #{ direction }")
    when /^title_/
      order("LOWER(programs.title) #{ direction }")
    when /^duration_/
      order("programs.time_min #{ direction }")
    when /^id_/
      order("programs.id #{ direction }")
    else
      raise(ArgumentError, "Sortier-Option ungueltig: #{ sort_option.inspect }")
    end
  }

  private
    def destroy_entries
      entries.each do |e|
        if not e.independent
          e.destroy
        end
      end
    end
end
