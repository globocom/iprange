require "spec_helper"

describe IPRange::Range do
  describe ".initialize" do
    subject do
      IPRange::Range
    end

    it "should accept redis config as argument" do
      redis_config = {host: "127.0.0.1"}
      expect(subject.new(redis_config))
    end

    it "should use config to connect to redis" do
      redis_config = double()
      Redis.should_receive(:new).with(redis_config)
      subject.new(redis_config)
    end
  end

  describe "when a range is added" do
    subject do
      IPRange::Range.new
    end

    before do
      subject.remove("192.168.0.1/24")
      subject.add("192.168.0.1/24")
    end

    it "should find it back" do
      response = subject.find("192.168.0.20")
      expect(response).to eq({range: "192.168.0.1/24"})
    end

    it "should return nil for smaller ip that is not in range" do
      response = subject.find("192.167.255.255")
      expect(response).to be_nil
    end

    it "should return nil for greater ip that is not in range" do
      response = subject.find("192.169.0.1")
      expect(response).to be_nil
    end
  end

  describe "when a range is added with metadata" do
    subject do
      IPRange::Range.new
    end

    before do
      subject.remove("192.168.0.1/24")
      subject.add("192.168.0.1/24", some: "data", more: "metadata")
    end

    it "should find it back" do
      response = subject.find("192.168.0.20")
      expect(response[:range]).to eq("192.168.0.1/24")
      expect(response["some"]).to eq("data")
      expect(response["more"]).to eq("metadata")
    end
  end
end
