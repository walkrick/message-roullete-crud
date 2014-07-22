require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "./lib/message_table"
require "./lib/comment_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    @message_table = MessageTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @comment_table = CommentTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{params[:id]}").first

    erb :"messages/edit", locals: {message: message}
  end

  patch "/messages/:id/patch" do
    message = params[:message]
    if message.length <= 140

      @message_table.update(params[:id], params[:message])

      flash[:notice] = "Message updated"
      redirect "/"

    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/messages/#{params[:id]}/edit"
    end
  end

  delete "/messages/:id" do
    @message_table.delete(params[:id])

    flash[:notice] = "Message deleted"

    redirect "/"
  end

  post "/comment/:id" do

    comment = params[:comment]
    if comment.length <= 140
      @database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('#{comment}', #{params[:id]})")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

end

