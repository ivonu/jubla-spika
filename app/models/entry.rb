class Entry < ActiveRecord::Base

  has_many :program_entries
  has_many :programs, through: :program_entries

  validates :title, presence: true
  validates :description, presence: true
  validates :keywords, presence: true
  validates :group_size_min, presence: true, numericality: true
  validates :group_size_max, presence: true, numericality: true
  validates :age_min, presence: true, numericality: true
  validates :age_max, presence: true, numericality: true
  validates :time_min, presence: true, numericality: true
  validates :time_max, presence: true, numericality: true

  
  filterrific(
    default_filter_params: {
      sorted_by: 'title_asc'
    },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_part_start,
      :with_part_main,
      :with_part_end,
      :with_indoors,
      :with_outdoors,
      :with_weather_snow,
      :with_weather_rain,
      :with_weather_sun,
      :with_act_active,
      :with_act_calm,
      :with_act_creative,
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

  scope :with_part_start, lambda { |flag| check_boolean_attr "part_start", flag }
  scope :with_part_main, lambda { |flag| check_boolean_attr "part_main", flag }
  scope :with_part_end, lambda { |flag| check_boolean_attr "part_end", flag }
  scope :with_indoors, lambda { |flag| check_boolean_attr "indoors", flag }
  scope :with_outdoors, lambda { |flag| check_boolean_attr "outdoors", flag }
  scope :with_weather_snow, lambda { |flag| check_boolean_attr "weather_snow", flag }
  scope :with_weather_rain, lambda { |flag| check_boolean_attr "weather_rain", flag }
  scope :with_weather_sun, lambda { |flag| check_boolean_attr "weather_sun", flag }
  scope :with_act_active, lambda { |flag| check_boolean_attr "act_active", flag }
  scope :with_act_calm, lambda { |flag| check_boolean_attr "act_calm", flag }
  scope :with_act_creative, lambda { |flag| check_boolean_attr "act_creative", flag }

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
      "(LOWER(entries.title) LIKE :q
      OR LOWER(entries.title_other) LIKE :q
      OR LOWER(entries.description) LIKE :q
      OR LOWER(entries.material) LIKE :q
      OR LOWER(entries.remarks) LIKE :q
      OR LOWER(entries.preparation) LIKE :q
      OR LOWER(entries.keywords) LIKE :q)",
      :q => "%#{query}%"
    )
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'

    case sort_option.to_s
    when /^title_/
      order("LOWER(entries.title) #{ direction }")
    when /^duration_/
      order("LOWER(entries.time_min) #{ direction }")
    when /^created_at_/
      order("LOWER(entries.created_at) #{ direction }")
    else
      raise(ArgumentError, "Sortier-Option ungueltig: #{ sort_option.inspect }")
    end
  }


  def self.options_for_num_group
    [
      ['-',   ''],
      ['2',   '2'],
      ['3',   '3'],
      ['4',   '4'],
      ['5',   '5'],
      ['6',   '6'],
      ['8',   '8'],
      ['10',  '10'],
      ['15',  '15'],
      ['20',  '20'],
      ['30',  '30'],
      ['50',  '50'],
      ['70',  '70'],
      ['100', '100']
    ]
  end

  def self.options_for_num_age
    [
      ['-',  ''],
      ['5',  '5'],
      ['6',  '6'],
      ['7',  '7'],
      ['8',  '8'],
      ['9',  '9'],
      ['10', '10'],
      ['12', '12'],
      ['14', '14'],
      ['16', '16'],
      ['18', '18'],
      ['20', '20'],
      ['30', '30'],
      ['40', '40'],
      ['50', '50'],
      ['70', '70'],
      ['99', '99']
    ]
  end

  def self.options_for_num_time
    [
      ['-',  ''],
      ['5 Minuten',  '5'],
      ['10 Minuten', '10'],
      ['15 Minuten', '15'],
      ['20 Minuten', '20'],
      ['30 Minuten', '30'],
      ['45 Minuten', '45'],
      ['1 Stunde',   '60'],
      ['2 Stunden',  '120'],
      ['3 Stunden',  '180']
    ]
  end

  def self.options_for_sorted_by
    [
      ['Titel', 'title_asc'],
      ['Dauer', 'duration_asc'],
      ['Neuigkeit', 'created_at_desc']
    ]
  end

end
