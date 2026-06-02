require "csv_source"
require "tempfile"

RSpec.describe CsvSource do
  describe "::load" do
    def with_csv(contents)
      Tempfile.create(["bulk", ".csv"]) do |file|
        file.write(contents)
        file.flush
        yield file.path
      end
    end

    it "yields each row in a bulk CSV with underscored symbol keys" do
      csv = <<~CSV
        url,name,description,documentation,maintainer,provider,providerUrl
        https://api.example.gov.uk/one,API One,First API,https://docs.example.gov.uk/one,team-one@example.gov.uk,Example Department,https://example.gov.uk
        https://api.example.gov.uk/two,API Two,Second API,https://docs.example.gov.uk/two,team-two@example.gov.uk,Example Department,https://example.gov.uk
        https://api.example.gov.uk/three,API Three,Third API,https://docs.example.gov.uk/three,team-three@example.gov.uk,Other Department,https://other.gov.uk
      CSV

      with_csv(csv) do |path|
        rows = described_class.load(path) { |row| row }

        expect(rows.size).to eq(3)
        expect(rows.first).to include(
          url: "https://api.example.gov.uk/one",
          name: "API One",
          provider: "Example Department",
          provider_url: "https://example.gov.uk",
        )
        expect(rows.map { |r| r[:name] }).to eq(["API One", "API Two", "API Three"])
      end
    end

    it "returns the values produced by the block for every row" do
      csv = <<~CSV
        url,name
        https://a,Alpha
        https://b,Bravo
      CSV

      with_csv(csv) do |path|
        names = described_class.load(path) { |row| row[:name] }
        expect(names).to eq(%w[Alpha Bravo])
      end
    end

    it "returns an empty array when the CSV has only a header row" do
      with_csv("url,name\n") do |path|
        expect(described_class.load(path) { |row| row }).to eq([])
      end
    end
  end
end
