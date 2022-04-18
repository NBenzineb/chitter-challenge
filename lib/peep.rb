require 'pg'

class Peep
 attr_reader :id, :message

  def initialize(id:, message:)
    @id = id
    @message = message
  end

  def self.all
    if ENV['RACK_ENV'] == 'test'
        connection = PG.connect(dbname: 'peeps_manager_test')
    else 
        connection = PG.connect(dbname: 'peeps_manager')
    end

    result = connection.exec("SELECT * FROM peeps;")
    list_of_peeps =result.map do |peep|
        Peep.new(id: peep['id'], message: peep['message'])
    end

    list_of_peeps.reverse

  end

  def self.create(message:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect( dbname: 'peeps_manager_test')
    else
      connection = PG.connect( dbname: 'peeps_manager')
    end

    result = connection.exec_params("INSERT INTO peeps (message) VALUES ($1) RETURNING id, message;", [message])
    Peep.new(id: result[0]['id'], message: result[0]['message'])
  end

end
