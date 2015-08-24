module Amatista
  class Model
    # Executes a query against a database.
    # Example
    # ```crystal
    # class Task < Amatista::Model
    #   def self.all
    #     records = [] of String
    #     connect {|db| records = db.exec("select * from tasks order by done").rows }
    #     records
    #   end
    # end
    # ```
    def self.connect
      if $amatista.database_driver == "postgres"
        db = PG::Connection.new($amatista.database_connection)
        yield(db)
        db.finish
      end
    end
  end
end
