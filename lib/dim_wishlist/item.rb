require 'dim_wishlist/roll'

class WishlistItem
  attr_accessor :info, :notes, :rolls

  class << self
    def parse(lines)
      self.new.parse(lines)
    end
  end

  def initialize(info: [], notes: [], rolls: [])
    @info  = info
    @notes = notes
    @rolls = rolls
  end

  def ids
    @rolls.map(&:item_id).uniq
  end

  def has_roll?(item_id, perks)
    @rolls.any? do |roll|
      roll.item_id == item_id &&
        roll.perks.all? do |perk|
          perks.include? perk
        end
    end
  end

  def to_s
    ["// #{@info.join('. ')}", "// #{@notes.join('. ')}", @rolls.values.map(&:to_s), "\n"]
      .flatten.join("\n")
  end

  def parse(lines)
    lines.each do |line|
      case line
      when %r{^// .*} then handle_info_line(line)
      when %r{^//notes:} then handle_notes_line(line)
      when /^dimwishlist:/ then handle_wishlist_line(line)
      end
    end

    self
  end

  private
  def handle_info_line(line)
    @info << line.split('// ').last
  end

  def handle_notes_line(line)
    @notes << line.split('//notes:').last
  end

  def handle_wishlist_line(line)
    params      = line.split('dimwishlist:').last.split('&')
    note_params = params.last.split('#notes:')
    notes       = note_params.last if note_params.length > 1
    item_id     = params.first.split('=').last
    perks       = note_params.first.split('=').last.split(',')

    @rolls << Roll.new(item_id: item_id, perks: perks, notes: notes)
  end
end
