class CommentTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def update(id, comment)
    update_sql = <<-SQL
    UPDATE comments
    SET comment = '#{comment}'
    WHERE id = #{id}
    SQL
    database_connection.sql(update_sql)
  end

  def delete(id)
    delete_sql = <<-SQL
    DELETE
    FROM comments
    WHERE id = #{id}
    SQL

    database_connection.sql(delete_sql)
  end
end