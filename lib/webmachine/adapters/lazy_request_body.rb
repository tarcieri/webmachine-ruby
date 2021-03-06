
module Webmachine
  module Adapters
    # Wraps a request body so that it can be passed to
    # {Request} while still lazily evaluating the body.
    class LazyRequestBody
      def initialize(request)
        @request = request
      end

      # Converts the body to a String so you can work with the entire
      # thing.
      def to_s
        @value ? @value.join : @request.body
      end

      # Iterates over the body in chunks. If the body has previously
      # been read, this method can be called again and get the same
      # sequence of chunks.
      # @yield [chunk]
      # @yieldparam [String] chunk a chunk of the request body
      def each
        if @value
          @value.each {|chunk| yield chunk }
        else
          @value = []
          @request.body {|chunk| @value << chunk; yield chunk }
        end
      end
    end # class RequestBody
  end # module Adapters
end # module Webmachine
