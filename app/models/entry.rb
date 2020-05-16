class Entry < ActiveRecord::Base

  before_validation :sanitize_content

  has_many :program_entries, dependent: :destroy
  has_many :programs, through: :program_entries
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user
  belongs_to :edited_entry, :class_name => 'Entry', :foreign_key => 'edited_entry'
  belongs_to :delete_user, :class_name => 'User', :foreign_key => 'delete_user'

  validates :title, presence: true
  validates :description, presence: true
  validates :keywords, presence: true
  validates :group_size_min, presence: true, numericality: true
  validates :group_size_max, presence: true, numericality: true
  validates :time_min, presence: true, numericality: true
  validates :time_max, presence: true, numericality: true

  
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
      :with_act_active,
      :with_act_calm,
      :with_act_creative,
      :with_act_talk,
      :with_act_distance,
      :with_cat_game, 
      :with_cat_shape,
      :with_cat_group,
      :with_cat_jubla,
      :with_age_5,
      :with_age_8,
      :with_age_12,
      :with_age_15,
      :with_age_17,
      :num_group_min,
      :num_group_max,
      :num_time_min,
      :num_time_max
    ]
  )

  def self.check_boolean_attr attr_name, attr_value
    return nil  if 0 == attr_value
    where(attr_name.to_sym => true)
  end

  scope :only_programs, lambda { |flag| }
  scope :with_part_start, lambda { |flag| check_boolean_attr "part_start", flag }
  scope :with_part_main, lambda { |flag| check_boolean_attr "part_main", flag }
  scope :with_part_end, lambda { |flag| check_boolean_attr "part_end", flag }
  scope :with_age_5, lambda { |flag| check_boolean_attr "age_5", flag }
  scope :with_age_8, lambda { |flag| check_boolean_attr "age_8", flag }
  scope :with_age_12, lambda { |flag| check_boolean_attr "age_12", flag }
  scope :with_age_15, lambda { |flag| check_boolean_attr "age_15", flag }
  scope :with_age_17, lambda { |flag| check_boolean_attr "age_17", flag }
  scope :with_indoors, lambda { |flag| check_boolean_attr "indoors", flag }
  scope :with_outdoors, lambda { |flag| check_boolean_attr "outdoors", flag }
  scope :with_act_active, lambda { |flag| check_boolean_attr "act_active", flag }
  scope :with_act_calm, lambda { |flag| check_boolean_attr "act_calm", flag }
  scope :with_act_creative, lambda { |flag| check_boolean_attr "act_creative", flag }
  scope :with_act_talk, lambda { |flag| check_boolean_attr "act_talk", flag }
  scope :with_act_distance, lambda { |flag| check_boolean_attr "act_distance", flag }
  scope :with_cat_game, lambda { |flag| check_boolean_attr "cat_game", flag }
  scope :with_cat_shape, lambda { |flag| check_boolean_attr "cat_shape", flag }
  scope :with_cat_group, lambda { |flag| check_boolean_attr "cat_group", flag }
  scope :with_cat_jubla, lambda { |flag| check_boolean_attr "cat_jubla", flag }

  def self.check_integer_attr attr_name, attr_value, comp
    return nil  if attr_value.blank?
    return nil  if !attr_value.is_a? Integer
    where("#{attr_name} #{comp} #{attr_value.to_s}")
  end

  scope :num_group_min, lambda { |num| check_integer_attr "group_size_min", num, "<="}
  scope :num_group_max, lambda { |num| check_integer_attr "group_size_max", num, ">="}
  scope :num_time_min, lambda { |num| check_integer_attr "time_min", num, "<="}
  scope :num_time_max, lambda { |num| check_integer_attr "time_max", num, ">="}

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)
    terms = terms.map { |e| ('%' + e + '%') }

    num_or_conds = 7
    where(
      terms.map { |term|
        "(LOWER(entries.title) LIKE ?
        OR LOWER(entries.title_other) LIKE ?
        OR LOWER(entries.description) LIKE ?
        OR LOWER(entries.material) LIKE ?
        OR LOWER(entries.remarks) LIKE ?
        OR LOWER(entries.preparation) LIKE ?
        OR LOWER(entries.keywords) LIKE ?)"
      }.join(' OR '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'

    case sort_option.to_s
    when /^rating_/
      order("entries.rating_calc #{ direction }")
    when /^title_/
      order("LOWER(entries.title) #{ direction }")
    when /^duration_/
      order("entries.time_min #{ direction }")
    when /^id_/
      order("entries.id #{ direction }")
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
      ['Bewertung', 'rating_desc'],
      ['Titel', 'title_asc'],
      ['Dauer', 'duration_asc'],
      ['Neuigkeit', 'id_desc']
    ]
  end

  private
    def sanitize_content
      self.description = ActionController::Base.helpers.sanitize self.description
    end

end
