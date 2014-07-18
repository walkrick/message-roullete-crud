require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection ||= DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    @messages = @database_connection.sql("SELECT * FROM messages")

    erb :home
  end

  post "/message" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:notice] = ""[:notice] = "Error: restrict your message to only 140 characters."
    end
    redirect "/"
  end

end