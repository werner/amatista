module Amatista
  class Model
    def self.connect
      if $amatista.database_driver == "postgres"
        db = PG::Connection.new($amatista.database_connection)
        yield(db)
        db.finish
      end
    end
  end
end
