require "../../spec_helper"

module Awscr
  module Signer
    module Presigned
      describe Url do
        describe "get" do
          it "generates a correct url" do
            Timecop.freeze(Time.new(2013, 5, 24)) do
              scope = Scope.new("us-east-1", "s3", Time.now)
              creds = Credentials.new("AKIAIOSFODNN7EXAMPLE",
                "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")

              url = Url.new("/test.txt", "examplebucket", scope, creds)

              url.get.should eq("https://examplebucket.s3.amazonaws.com/test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIOSFODNN7EXAMPLE%2F20130524%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20130524T000000Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=aeeed9bbccd4d02ee5c0109b86d86835f995330da4c265957d157751f604d404")
            end
          end
        end
      end
    end
  end
end
