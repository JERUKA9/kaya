require 'test/unit'
require 'board/square_tag'
require 'board/point_converter'
require 'rubygems'
require 'mocha'

class FakeTaggableBoard
  include PointConverter
  extend TaggableSquares
  
  square_tag :selection
  
  class FakeTheme
    def method_missing(m, *args)
      self
    end
  end
  
  def theme
    FakeTheme.new
  end
  
  def unit
    Point.new(10, 10)
  end
end

class TestSquareTag < Test::Unit::TestCase
  def setup
    @board = FakeTaggableBoard.new
  end
  
  def test_tag_methods
    assert @board.respond_to?(:selection)
    assert @board.respond_to?(:selection=)
  end
  
  def test_empty_initial_tag
    assert_nil @board.selection
  end
  
  def test_set_retrieve_tag
    @board.expects(:add_item).with do |name, pix, args|
      name == :selection and args[:pos] == Point.new(30.0, 20.0)
    end
    @board.selection = Point.new(3, 2)
    assert_equal Point.new(3, 2), @board.selection
  end
  
  def test_set_cancel_tag
    @board.expects(:add_item).with do |name, pix, args|
      name == :selection and args[:pos] == Point.new(50.0, 30.0)
    end
    @board.expects(:remove_item).with(:selection)
    
    @board.selection = Point.new(5, 3)
    @board.selection = nil
    assert_nil @board.selection
  end
end