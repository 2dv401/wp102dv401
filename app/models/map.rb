class Map < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :user

  ## Skapa api nyckel
  before_create :generate_api_key

  belongs_to :user
  belongs_to :location

  has_and_belongs_to_many :tags, uniq: true
  before_destroy { tags.clear }

  has_many :marks, dependent: :destroy
  has_many :status_updates, order: "created_at DESC", dependent: :destroy
  has_many :map_comments, order: "created_at DESC", dependent: :destroy

  acts_as_followable
  acts_as_gmappable

  accepts_nested_attributes_for :location

  MAP_TYPES = [ "HYBRID", "ROADMAP", "SATELLITE", "TERRAIN"]

  attr_accessor :longitude, :latitude
  attr_accessible :name, :description, :private, :zoom, :map_type, :location_attributes

  validates	:name, presence: true, length: { maximum: 50 }
  validates	:description, length: { maximum: 15360 }
  validates :private, inclusion: {in: [true, false]}
  validates :map_type, inclusion: MAP_TYPES
  validates :zoom, numericality: { only_integer: true }

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

  ## Genererar en API nyckel på alla nya kartor.  - alla nycklar blir unika.
  def generate_api_key
    begin
      @api_key = SecureRandom.urlsafe_base64
    end while Map.where(api_key: @api_key).exists?
    self.api_key = api_key
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

end