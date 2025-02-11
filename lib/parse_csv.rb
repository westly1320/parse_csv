# frozen_string_literal: true

require 'parse_csv/version'
require 'csv'

# Module to parse CSV files and query rows based on criteria.
module ParseCsv
  class Error < StandardError; end

  # Reads a CSV file and returns rows matching the query_hash criteria.
  #
  # @param file_path [String] Path to the CSV file.
  # @param query_hash [Hash] Hash with column headers as keys and criteria as values.
  # @return [Array<Hash>] Array of hashes representing matching rows.
  def self.query_csv(file_path, query_hash)
    validate_inputs(file_path, query_hash)

    results = []
    normalized_query = symbolize_keys(query_hash)
    expected_columns = nil

    begin
      CSV.foreach(file_path, headers: true, header_converters: ->(header) { header.strip.downcase.to_sym }) do |row|
        # Initialize expected_columns based on the first row
        expected_columns = row.headers.length if expected_columns.nil?

        # Check if the current row has the expected number of columns
        if row.length != expected_columns
          raise Error, "Malformed CSV: Expected #{expected_columns} columns, but got #{row.length} in row #{row.inspect}"
        end

        row_hash = row.to_hash

        # Raise an error if any value is nil (indicating a missing field)
        raise Error, "Malformed CSV: Missing fields in row #{row.inspect}" if row_hash.values.any?(&:nil?)

        results << row_hash if match_row?(row_hash, normalized_query)
      end
    rescue CSV::MalformedCSVError => e
      raise Error, "Malformed CSV file: #{e.message}"
    end

    results
  end

  # Validates the inputs for the query_csv method.
  def self.validate_inputs(file_path, query_hash)
    unless file_path.is_a?(String) && !file_path.strip.empty?
      raise Error, 'Invalid file_path. It must be a non-empty string.'
    end

    unless query_hash.is_a?(Hash) && query_hash.keys.all? { |k| k.is_a?(String) || k.is_a?(Symbol) }
      raise Error, 'Invalid query_hash. It must be a hash with string or symbol keys representing column headers.'
    end

    raise Error, "File not found: #{file_path}" unless File.exist?(file_path)
  end

  # Symbolizes and downcases the keys of a hash
  def self.symbolize_keys(hash)
    hash.each_with_object({}) do |(k, v), memo|
      memo[k.to_s.strip.downcase.to_sym] = v
    end
  end

  # Checks if a row matches all criteria in the query_hash.
  def self.match_row?(row_hash, query_hash)
    query_hash.all? do |key, value|
      row_hash[key] == value
    end
  end
end
