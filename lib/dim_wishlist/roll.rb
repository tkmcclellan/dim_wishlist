require 'digest'

class Roll
  attr_accessor :perks, :item_id, :notes

  class << self
    def key(item_id, perks)
      Digest::SHA2.new(512).hexdigest "#{item_id},#{perks.join(',')}"
    end
  end

  def initialize(item_id:, perks:, notes: nil)
    @item_id = item_id
    @perks   = perks
    @notes   = notes
  end

  def key
    self.class.key(@item_id, @perks)
  end

  def to_s
    "dimwishlist:item=#{@item_id}&perks=#{perks.join(',')}#{!@notes.nil? ? "#notes:#{notes}" : ''}"
  end
end
