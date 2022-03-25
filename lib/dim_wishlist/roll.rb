require 'digest'

class Roll
  attr_accessor :perks, :item_id, :notes

  def initialize(item_id:, perks:, notes: nil)
    @item_id = item_id
    @perks   = perks
    @notes   = notes
  end

  def to_s
    "dimwishlist:item=#{@item_id}&perks=#{perks.join(',')}#{!@notes.nil? ? "#notes:#{notes}" : ''}"
  end
end
