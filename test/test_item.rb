require 'minitest/autorun'
require 'dim_wishlist'

class ItemTest < Minitest::Test
  def setup
    @item  = WishlistItem.new
    @info  = ['Test info 1', 'Test info 2']
    @notes = ['Test notes']
    @lines = [
      @info.map {|info| "// #{info}" },
      @notes.map {|note| "//notes:#{note}" },
      'dimwishlist:item=123&perks=1,2,3,4,5',
      'dimwishlist:item=234&perks=2,3,4,5,6#notes:item notes'
    ].flatten
    @rolls = [
      Roll.new(item_id: '123', perks: ['1', '2', '3', '4', '5']),
      Roll.new(item_id: '234', perks: ['2', '3', '4', '5', '6'], notes: 'item notes')
    ]
    @hash_rolls = @rolls.each_with_object({}) do |roll, accum|
      accum[roll.key] = roll
    end
  end

  def test_creates_empty_item
    assert_equal([], @item.info)
    assert_equal([], @item.notes)
    assert_equal({}, @item.rolls)
  end

  def test_creates_non_empty_item
    item = WishlistItem.new(info: @info, notes: @notes, rolls: @rolls)

    assert_equal(@info, item.info)
    assert_equal(@notes, item.notes)
    assert_equal(@hash_rolls, item.rolls)
  end

  # DEPRECATE
  def test_parses_data_from_lines
    @item.parse(@lines)
    rolls = @rolls.each_with_object({}) do |roll, accum|
      accum[roll.key] = roll
    end

    assert_equal(['Test info 1', 'Test info 2'], @item.info)
    assert_equal(['Test notes'], @item.notes)
    assert_equal(rolls, @item.rolls)
  end

  def test_parses_info
  end

  def test_parses_notes
  end

  def test_parses_rolls
  end

  def test_returns_list_of_ids
  end

  def test_search_rolls_by_id
  end

  def test_search_rolls_by_perks
  end

  def test_search_rolls_by_id_and_perks
  end

  def test_checks_if_roll_exists
  end

  def test_add_roll
  end

  def test_remove_roll
  end

  def test_renders_to_string
  end
end
