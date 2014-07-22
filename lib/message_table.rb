class MessageTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def update(id, message)
    update_sql = <<-SQL
    UPDATE messages
    SET message = '#{message}'
    WHERE id = #{id}
    SQL
    database_connection.sql(update_sql)
  end

  def delete(id)
    delete_sql = <<-SQL
    DELETE
    FROM messages
    WHERE id = #{id}
    SQL

    database_connection.sql(delete_sql)
  end
  end