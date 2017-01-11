require "multipart"
require "http/client"
require "secure_random"

module Awscr
  module Signer
    module Presigned
      class Form
        @client : HTTP::Client

        # Create a new `Form`
        #
        # Building a `Form`
        #
        # ```
        # Awscr::Signer::Presigned::Form.build(REGION, creds) do |form|
        #   form.expiration(Time.epoch(Time.now.epoch + 1000))
        #   form.condition("bucket", BUCKET)
        #   form.condition("acl", "public-read")
        #   form.condition("key", "key")
        #   form.condition("Content-Type", "image/png")
        #   form.condition("success_action_status", "201")
        # end
        # ```
        def self.build(region, credentials, &block)
          post = Post.new(region, credentials)
          post.build do |p|
            yield p
          end
          new(post, HTTP::Client.new(URI.parse(post.url)))
        end

        # Create a form with a Post object and an IO.
        def initialize(@post : Post, client : HTTP::Client)
          @boundary = SecureRandom.uuid
          @client = client
        end

        # Submit the form
        def submit(io : IO)
          @client.post("/", headers, body(io).to_s)
        end

        # Represent this `Presigned::Form` as raw HTML.
        def to_html
          HtmlPrinter.new(self)
        end

        # The url of the form
        def url
          @post.url
        end

        # The fields of the form
        def fields
          @post.fields
        end

        private def headers
          HTTP::Headers{"Content-Type" => %(multipart/form-data; boundary="#{@boundary}")}
        end

        private def body(io : IO)
          body_io = IO::Memory.new
          HTTP::FormData.generate(body_io, @boundary) do |form|
            @post.fields.each do |field|
              form.field(field.key, field.value)
            end
            form.file("file", io)
          end
          body_io
        end
      end
    end
  end
end
