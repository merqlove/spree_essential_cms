class Spree::PageImage < Spree::Asset
  has_attached_file :attachment,
                    :styles => lambda { |clip| clip.instance.attachment_sizes },
                    :default_style => :medium,
                    :url => '/spree/pages/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/pages/:id/:style/:basename.:extension'

  validates_attachment :attachment,
                       :presence => true

  default_scope -> { order(:position) }

  def self.update_all_positions(positions)
    update(positions.keys, positions.values.map {|i| {:position => i} })
  end

  def image_content?
    attachment_content_type.to_s.match(/\/(jpeg|png|gif|tiff|x-photoshop)/)
  end

  def attachment_sizes
    sizes = {}
    if image_content?
      sizes.merge!(:mini => '48x48>', :small => '150x150>', :medium => '420x300>', :large => '900x650>')
      sizes.merge!(:slide => '950x250#') if viewable.respond_to?(:root?) && viewable.root?
    end
    sizes
  end

end
