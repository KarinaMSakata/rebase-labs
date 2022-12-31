rows = CSV.read("./data.csv", col_sep: ';')

columns = rows.shift

rows.map do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end.to_json