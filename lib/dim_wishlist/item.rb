require 'dim_wishlist/roll'

class WishlistItem
  attr_accessor :info, :notes, :rolls

  def initialize(lines)
    @info  = []
    @notes = []
    @rolls = {}
    lines.each { |line| process(line) }
  end

  def item_ids
    @rolls.values.map(&:item_id).uniq
  end

  def has_roll?(item_id, perks)
    !@rolls[Roll.key(item_id, perks)].nil?
  end

  def to_s
    ["// #{@info.join('. ')}", "// #{@notes.join('. ')}", @rolls.values.map(&:to_s), "\n"].flatten.join("\n")
  end

  private

  def process(line)
    case line
    when %r{^// .*} then handle_info_line(line)
    when %r{^//notes:} then handle_notes_line(line)
    when /^dimwishlist:/ then handle_wishlist_line(line)
    end
  end

  def handle_info_line(line)
    @info << line.split('// ').last
  end

  def handle_notes_line(line)
    @notes << line.split('//notes:').last
  end

  def handle_wishlist_line(line)
    params      = line.split('dimwishlist:').last.split('&')
    note_params = params.last.split('#notes')
    notes       = note_params.last if note_params.length > 1
    item_id     = params.first.split('=').last
    perks       = params[1].split('=').last.split(',')
    roll        = Roll.new(item_id: item_id, perks: perks, notes: notes)

    @rolls[roll.key] = roll
  end
end
