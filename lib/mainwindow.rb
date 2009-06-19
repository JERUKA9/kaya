require 'qtutils'
require 'board/board'
require 'board/table'
require 'history'
require 'controller'

class MainWindow < KDE::XmlGuiWindow
  include ActionHandler
  
  Theme = Struct.new(:pieces, :board)
  
  def initialize(loader, game)
    super nil
    
    @loader = loader
    
    load_board(game)
    
    setup_actions
    setupGUI
  end

private

  def setup_actions
    std_action :open_new do
      puts "new game"
    end
    std_action :quit, :close
  end
  
  def load_board(game)
    config = KDE::Global.config.group('themes')
    
    theme = Theme.new
    theme.pieces = @loader.get_matching(nil, game,
      (game.keywords || []) + ['pieces'], [])
    theme.board = @loader.get_matching(nil, game,
      ['board'], game.keywords || [])
    
    scene = Qt::GraphicsScene.new
    
    state = game.state.new.tap {|s| s.setup }
    
    board = Board.new(scene, theme, game, state)
    
    table = Table.new(scene, self, board)
    self.central_widget = table

    history = History.new(state)
    controller = Controller.new(board, history)
  end
end