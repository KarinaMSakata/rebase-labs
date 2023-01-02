require 'csv'
require 'pg'

class QueryCsv
  attr_accessor :conn

  def initialize
    @conn = PG.connect(host 'postgres', dbname: 'postgres', user: 'postgres' )
    create_table
    insert_data
  end

  def csv_data
    rows = CSV.read("./data.csv", col_sep: ';')

    columns = rows.shift
  
    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end
  end

  def create_table
    @conn.exec("
      CREATE TABLE exams (
        id SERIAL PRIMARY KEY, 
        cpf VARCHAR(14) NOT NULL,
        nome_paciente VARCHAR(100) NOT NULL,
        email_paciente VARCHAR(100) NOT NULL,
        data_nascimento_paciente DATE NOT NULL,
        endereço_rua_paciente VARCHAR(150) NOT NULL,
        cidade_paciente VARCHAR(50) NOT NULL,
        estado_paciente VARCHAR(50) NOT NULL,
        crm_medico VARCHAR(20) NOT NULL,
        crm_medico_estado VARCHAR(2) NOT NULL,
        nome_medico VARCHAR(100) NOT NULL,
        email_medico VARCHAR(100) NOT NULL,
        token_resultado_exame VARCHAR(10) NOT NULL,
        data_exame DATE NOT NULL,
        tipo_exame VARCHAR(50) NOT NULL,
        limites_tipo_exame VARCHAR(10) NOT NULL,
        resultado_tipo_exame VARCHAR(10) NOT NULL);
      ")
  end

  def insert_data
    csv_data.each do |row|
      @conn.exec("INSERT INTO exams (cpf, nome_paciente, email_paciente, data_nascimento_paciente,
                                        endereço_rua_paciente, cidade_paciente, estado_paciente, crm_medico,
                                        crm_medico_estado, nome_medico, email_medico, token_resultado_exame, 
                                        data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame) 
                    VALUES ('#{row['cpf']}', '#{row['nome_paciente']}'  , '#{row['email_paciente']}', '#{row['data_nascimento_paciente']}',
                    '#{row['endereço_rua_paciente']}', '#{row['cidade_paciente']}', '#{row['estado_paciente']}', '#{row['crm_medico']}',
                    '#{row['crm_medico_estado']}', '#{row['nome_medico']}', '#{row['email_medico']}', '#{row['token_resultado_exame']}', 
                    '#{row['data_exame']}', '#{row['tipo_exame']}', '#{row['limites_tipo_exame']}', '#{row['resultado_tipo_exame']}' 
                    ")
    end

    def all
      conn.exec('SELECT * FROM exams').to_a
    end
  end
end 
