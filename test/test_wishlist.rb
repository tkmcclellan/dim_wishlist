require 'minitest/autorun'
require 'dim_wishlist'

class WishlistTest < Minitest::Test
  def test_creates_empty_wishlist
    assert_equal({}, Wishlist.new.items)
  end
end
