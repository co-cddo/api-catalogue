require "fetcher"

RSpec.describe FetcherService do
  let(:fetcher1) { instance_double(Fetcher, "v1") }
  let(:fetcher2) { instance_double(Fetcher, "v2") }

  describe "#fetch" do
    it "delegates to a configured fetcher" do
      allow(fetcher1).to receive(:fetch).with(any_args)
      fetcher_service = described_class.new([fetcher1])
      expect(fetcher1).to receive(:fetch).with("https://www.example.com")
      fetcher_service.fetch("https://www.example.com")
    end

    it "only goes to fetcher2 if fetcher1 raises an error" do
      allow(fetcher1).to receive(:fetch).with(any_args).and_raise VersionNotSupportedError
      allow(fetcher2).to receive(:fetch).with(any_args)
      fetcher_service = described_class.new([fetcher1, fetcher2])

      expect(fetcher1).to receive(:fetch).with("https://www.example.com")
      expect(fetcher2).to receive(:fetch).with("https://www.example.com")

      fetcher_service.fetch("https://www.example.com")
    end

    it "returns the list of APIs when the fetcher succeeds" do
      apis = double
      allow(fetcher1).to receive(:fetch).with(any_args).and_return apis
      allow(fetcher2).to receive(:fetch).with(any_args)
      fetcher_service = described_class.new([fetcher1, fetcher2])

      expect(fetcher_service.fetch("https://www.example.com")).to eq apis
    end

    it "bubbles up a TemporaryError if one is raised" do
      allow(fetcher1).to receive(:fetch).with(any_args).and_raise TemporaryError
      fetcher_service = described_class.new([fetcher1])

      expect { fetcher_service.fetch("https://www.example.com") }.to raise_error TemporaryError
    end

    it "bubbles up a ClientError if one is raised" do
      allow(fetcher1).to receive(:fetch).with(any_args).and_raise ClientError
      fetcher_service = described_class.new([fetcher1])

      expect { fetcher_service.fetch("https://www.example.com") }.to raise_error ClientError
    end

    it "raises a ClientError if we weren't able to successfully fetch anything" do
      allow(fetcher1).to receive(:fetch).with(any_args).and_raise VersionNotSupportedError
      allow(fetcher2).to receive(:fetch).with(any_args).and_raise VersionNotSupportedError
      fetcher_service = described_class.new([fetcher1, fetcher2])

      expect { fetcher_service.fetch("https://www.example.com") }.to raise_error ClientError
    end
  end
end
