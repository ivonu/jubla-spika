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
  scope :with_part_start, lambda { |flag| }
  scope :with_part_main, lambda { |flag| }
  scope :with_part_end, lambda { |flag| }
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
      order("programs.rating_calc #{ direction }")
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
