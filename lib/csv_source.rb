require "csv"

class CsvSource
  HEADER_CONVERTER = ->(header) { header.underscore.to_sym }

  def self.load(csv_path)
    CSV
      .foreach(csv_path, headers: true, header_converters: [HEADER_CONVERTER])
      .map { |row| yield(row.to_hash) }
  end
end
