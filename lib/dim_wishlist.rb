# frozen_string_literal: true

require 'net/http'

require 'dim_wishlist/item'
require 'dim_wishlist/roll'

class Wishlist
  attr_accessor :items

  WISHLIST_URI = 'https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/choosy_voltron.txt'

  class << self
    def parse(wishlist_uri = WISHLIST_URI)
      instance = self.new
      body     = get_wishlist_text(wishlist_uri)

      return if body.nil?

      lines = []
      body.split("\n").each do |line|
        if line =~ %r{// [a-zA-Z(]|//notes:|dimwishlist:}
          lines << line
        elsif lines.length.positive?
          instance.add_item(WishlistItem.new(lines)) rescue nil
          lines.clear
        end
      end

      instance
    end

    private

    def get_wishlist_text(wishlist_uri)
      uri = URI(wishlist_uri)
      res = Net::HTTP.get_response(uri)

      res.body if res.is_a?(Net::HTTPSuccess)
    end
  end

  def initialize(wishlist_items = [])
    @items = {}
    wishlist_items.each(&:add_item)
  end

  def add_item(wishlist_item)
    wishlist_item.item_ids.each do |id|
      @items[id] ||= []
      @items[id] << wishlist_item
      @items[id].uniq!
    end

    wishlist_item
  end

  def items_with_id(id)
    @items[id] || []
  end

  def wishlist_item?(id, perks)
    items_with_id(id).any? { |item| item.has_roll?(id, perks) }
  end

  def to_s
    @items.values.flatten.map(&:to_s).join
  end
end
