require "../../spec_helper"

module Awscr
  module Signer
    module Presigned
      class TestField < PostField
        def serialize
        end
      end

      describe PostField do
        it "can be compared to a field" do
          field = TestField.new("key", "test")
          field2 = TestField.new("key", "test2")

          (field == field.dup).should be_true
          (field2 == field).should be_false
        end

        it "has a key" do
          field = TestField.new("key", "test")

          field.key.should eq "key"
        end

        it "has a value" do
          field = TestField.new("key", "test")

          field.value.should eq("test")
        end

        it "can use numbers" do
          field = TestField.new("key", 1)

          field.key.should eq "key"
          field.value.should eq(1)
        end
      end

      describe SimpleCondition do
        it "serializes" do
          field = SimpleCondition.new("k", "v")
          field.serialize.should eq({"k" => "v"})
        end
      end
    end
  end
end
