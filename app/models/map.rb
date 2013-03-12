class Map < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :user

  ## Skapa api nyckel
  before_create :generate_api_key
  before_destroy { tags.clear }
  # before_save :validate_tags

  belongs_to :user
  belongs_to :location

  has_and_belongs_to_many :tags, uniq: true


  has_many :marks, dependent: :destroy
  has_many :status_updates, order: "created_at DESC", dependent: :destroy
  has_many :map_comments, order: "created_at DESC", dependent: :destroy

  acts_as_followable
  acts_as_gmappable

  accepts_nested_attributes_for :location

  MAP_TYPES = [ "HYBRID", "ROADMAP", "SATELLITE", "TERRAIN"]
  MAX_TAG_COUNT = 5
  MAX_TAG_LENGTH = 20

  attr_accessor :longitude, :latitude
  attr_accessible :name, :description, :private, :zoom, :map_type, :location_attributes, :tag_list

  validates	:name, presence: true, length: { maximum: 50 }
  validates	:description, length: { maximum: 15360 }
  validates :private, inclusion: { in: [true, false] }
  validates :map_type, inclusion: MAP_TYPES
  validates :zoom, numericality: { only_integer: true }
  validate :validate_tags

  def follow(user)
    @follower = Follower.new()
    @follower.save
  end

  def longitude
    self.location.longitude
  end

  def latitude
    self.location.latitude
  end

  def tag_match_count(words)
    # Loopa igenom words
    @intersection = self.tags.map(&:word) & words
    return @intersection.size

    # kontrollera hur många gånger word finns i sina taggar
    # ++match
  end
  def tag_list
    self.tags.map(&:word).join(', ')
  end

  def tag_list=(words)
    self.tags = words.split(',').map do |word|
                      # Tar bort alla mellanslag
      Tag.where(word: word.gsub(/\s+/, "")).first_or_initialize
    end
  end

  ## Genererar en API nyckel på alla nya kartor.  - alla nycklar blir unika.
  def generate_api_key
    begin
      @api_key = SecureRandom.urlsafe_base64
    end while Map.where(api_key: @api_key).exists?
    self.api_key = @api_key
  end
  def comment_count
    self.map_comments.count
  end

  def follow_count
    self.followers('User').count
  end

  def status_count
    self.status_updates.count
  end

  def self.search_for(query)
    self.where("name like ?", "%#{query}%").all
  end

  def self.build_default_map
    return Map.new do |map|
      map.location = Location.new do |l|
        l.latitude = 60.0
        l.longitude = 15.0
      end
      map.map_type = "ROADMAP"
      map.zoom = 5
    end
  end
  

  private
  def validate_tags
    if self.tags.size > MAX_TAG_COUNT
      errors.add(:tag_list, I18n.t("maps.max_tag_count_reached", max: MAX_TAG_COUNT))
    end
    if self.tags.present?
      self.tags.each do |tag|
        if tag.word.length > MAX_TAG_LENGTH
          errors.add(:tag_list, I18n.t("maps.max_tag_length_reached", max: MAX_TAG_LENGTH))
        end
      end
    end
  end
end
