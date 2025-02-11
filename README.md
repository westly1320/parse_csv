# ParseCsv

ParseCsv is a Ruby gem designed for efficiently querying CSV files based on specified criteria. It handles large datasets gracefully by streaming data and returns matching rows as an array of hashes, ensuring optimal performance and minimal memory usage.

## Table of Contents

- [Installation](#installation)
    - [Using Bundler](#using-bundler)
    - [Installing Directly](#installing-directly)
- [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Querying with Multiple Criteria](#querying-with-multiple-criteria)
- [Error Handling](#error-handling)
    - [Example](#example)
- [Running Tests](#running-tests)
    - [Setup](#setup)
    - [Sample Output](#sample-output)
- [Contributing](#contributing)
    - [Steps to Contribute](#steps-to-contribute)
- [License](#license)

---

## Installation

You can install the `parse_csv` gem by adding it to your project's `Gemfile` or by installing it directly using the `gem` command.

### Using Bundler

Add this line to your application's `Gemfile`:

```ruby
gem 'parse_csv', '~> 0.1.0', github: 'git@github.com:westly1320/parse_csv.git'
```

Then execute:

```bash
bundle install
```

### Installing Directly

Alternatively, install the gem directly using the `gem` command:

```bash
gem install parse_csv
```

## Usage

### Basic Usage

To use `ParseCsv`, require it in your Ruby script and call the `query_csv` method with the path to your CSV file and a query hash containing your criteria.

```ruby
require 'parse_csv'

file_path = 'path/to/your/file.csv'
query = { 'Name' => 'John' }

begin
  results = ParseCsv.query_csv(file_path, query)
  puts "Matching Rows:"
  results.each do |row|
    puts row
  end
rescue ParseCsv::Error => e
  puts "An error occurred: #{e.message}"
end
```

### Querying with Multiple Criteria

You can refine your queries by including multiple key-value pairs in the `query_hash`.

```ruby
require 'parse_csv'

file_path = 'path/to/your/file.csv'
query = { 'Name' => 'John', 'Age' => '23' }

begin
  results = ParseCsv.query_csv(file_path, query)
  puts "Matching Rows:"
  results.each do |row|
    puts row
  end
rescue ParseCsv::Error => e
  puts "An error occurred: #{e.message}"
end
```

**Output:**

```
Matching Rows:
{:name=>"John", :age=>"23", :occupation=>"Designer", :location=>"Los Angeles", :salary=>"71094"}
{:name=>"John", :age=>"23", :occupation=>"Teacher", :location=>"Los Angeles", :salary=>"144998"}
```

## Error Handling

`ParseCsv` is built to handle various errors gracefully by raising `ParseCsv::Error` with meaningful messages. Here are some common scenarios:

- **File Not Found:** If the specified CSV file does not exist.
- **Invalid Query Format:** If the `query_hash` is not a valid hash with string or symbol keys representing column headers.
- **Malformed CSV:** If the CSV file has inconsistent columns or missing fields.

### Example

```ruby
require 'parse_csv'

file_path = 'path/to/nonexistent/file.csv'
query = { 'Name' => 'John' }

begin
  results = ParseCsv.query_csv(file_path, query)
rescue ParseCsv::Error => e
  puts "An error occurred: #{e.message}"
end
```

**Output:**

```
An error occurred: File not found: path/to/nonexistent/file.csv
```

## Running Tests

Ensuring that your gem works as expected is crucial. `ParseCsv` includes a comprehensive suite of unit tests using RSpec.

### Setup

1. **Install Dependencies:**

   Ensure all development dependencies are installed:

   ```bash
   bundle install
   ```

2. **Run Tests:**

   Execute the test suite with the following command:

   ```bash
   bundle exec rspec
   ```

**Sample Output:**

```
....

Finished in 0.12345 seconds (files took 0.67890 seconds to load)
6 examples, 0 failures
```

## Contributing

Bug reports and pull requests are welcome on GitHub. If you have suggestions for improvements or encounter issues, please open an issue or submit a pull request.

### Steps to Contribute

1. **Fork the Repository:**

   Click the **Fork** button on the repository's GitHub page to create your own copy.

2. **Clone the Fork:**

   ```bash
   git clone https://github.com/your_username/parse_csv.git
   cd parse_csv
   ```

3. **Create a New Branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Your Changes:**

   Implement your feature or fix.

5. **Run Tests:**

   Ensure all tests pass:

   ```bash
   bundle exec rspec
   ```

6. **Commit Your Changes:**

   ```bash
   git add .
   git commit -m "Add your commit message"
   ```

7. **Push to Your Fork:**

   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request:**

   Navigate to the original repository and submit a pull request from your fork.

## License

The gem is available as open-source under the terms of the [MIT License](LICENSE.txt).
