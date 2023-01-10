require 'csv'
require 'pg'

class QueryCsv
  attr_accessor :conn

  def initialize
    @conn = PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres')
    create_table
    insert_data
  end

  def create_table
    @conn.exec("
      CREATE TABLE IF NOT EXISTS EXAMS (
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

  def insert_data
    csv_data.each do |row|
      @conn.exec("INSERT INTO EXAMS (cpf, nome_paciente, email_paciente, data_nascimento_paciente,
                                        endereço_rua_paciente, cidade_paciente, estado_paciente, crm_medico,
                                        crm_medico_estado, nome_medico, email_medico, token_resultado_exame, 
                                        data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame) 
                                        VALUES ('#{row['cpf']}', '#{row['nome paciente']}', '#{row['email paciente']}',
                                        '#{row['data nascimento paciente']}', '#{row['endereço/rua paciente']}',
                                        '#{@conn.escape_string(row['cidade paciente'])}', '#{row['estado paciente']}',
                                        '#{row['crm médico']}', '#{row['crm médico estado']}', '#{row['nome médico']}',
                                        '#{row['email médico']}', '#{row['token resultado exame']}', '#{row['data exame']}',
                                        '#{row['tipo exame']}', '#{row['limites tipo exame']}',
                                        '#{row['resultado tipo exame']}')"
                                        )
    end
  end

  def all
    exams = conn.exec('SELECT * FROM EXAMS')
    exams.map { |exam| exam}.to_json
  end
    
end 
