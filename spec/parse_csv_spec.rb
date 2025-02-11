# spec/parse_csv_spec.rb

require "spec_helper"
require "parse_csv"

RSpec.describe ParseCsv do
  let(:valid_file) { File.join(__dir__, "fixtures", "sample.csv") }
  let(:invalid_file) { File.join(__dir__, "fixtures", "nonexistent.csv") }
  let(:malformed_csv) { File.join(__dir__, "fixtures", "malformed.csv") }

  before do
    # Create a malformed CSV for testing
    File.open(malformed_csv, "w") do |f|
      f.puts "Name,Age,Occupation,Location,Salary"
      f.puts "John,23,Designer,Los Angeles,71094"
      f.puts "Invalid Line Without Proper Columns"
      f.puts "Judie Walsh,22,Manager,Chicago,128149"
    end
  end

  after do
    # Clean up malformed CSV
    File.delete(malformed_csv) if File.exist?(malformed_csv)
  end

  describe ".query_csv" do
    context "with valid inputs" do
      it "returns matching rows as an array of hashes" do
        query = { "Name" => "John" }
        result = ParseCsv.query_csv(valid_file, query)
        expected = [
          { name: "John", age: "23", occupation: "Designer", location: "Los Angeles", salary: "71094" },
          { name: "John", age: "23", occupation: "Teacher", location: "Los Angeles", salary: "144998" }
        ]
        expect(result).to eq(expected)
      end

      it "returns an empty array when no rows match" do
        query = { "Name" => "Alice" }
        result = ParseCsv.query_csv(valid_file, query)
        expect(result).to eq([])
      end

      it "matches multiple criteria" do
        query = { "Name" => "John", "Age" => "23" }
        result = ParseCsv.query_csv(valid_file, query)
        expected = [
          { name: "John", age: "23", occupation: "Designer", location: "Los Angeles", salary: "71094" },
          { name: "John", age: "23", occupation: "Teacher", location: "Los Angeles", salary: "144998" }
        ]
        expect(result).to eq(expected)
      end
    end

    context "with invalid inputs" do
      it "raises an error if file does not exist" do
        query = { "Name" => "John" }
        expect { ParseCsv.query_csv(invalid_file, query) }.to raise_error(ParseCsv::Error, /File not found/)
      end

      it "raises an error if file_path is not a string" do
        query = { "Name" => "John" }
        expect { ParseCsv.query_csv(nil, query) }.to raise_error(ParseCsv::Error, /Invalid file_path/)
      end

      it "raises an error if query_hash is not a hash" do
        expect { ParseCsv.query_csv(valid_file, nil) }.to raise_error(ParseCsv::Error, /Invalid query_hash/)
      end

      it "raises an error for malformed CSV" do
        query = { "Name" => "John" }
        expect { ParseCsv.query_csv(malformed_csv, query) }.to raise_error(ParseCsv::Error, /Malformed CSV/)
      end
    end
  end
end
