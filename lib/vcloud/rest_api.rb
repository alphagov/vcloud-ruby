module VCloud
  module RestApi
    require 'restclient'

    def refresh(session=self.session)
      http_opts = build_generic_http_opts(@href, nil, nil, session, {})
      http_opts.merge!(:method => 'get')
      http_opts[:headers][:accept] = self.class.type+";version=#{session.api_version}"
      response = http_request(http_opts)
      parse_response(response)
    end

    def create
    end

    def update
    end

    def delete(url, payload, content_type, session=self.session, opts={})
      http_opts = build_generic_http_opts(url, payload, content_type, session, opts)
      http_opts.merge!(:method => 'delete')
      http_request(http_opts)
    end

    def post(url, payload, content_type, session=self.session, opts={})
      http_opts = build_generic_http_opts(url, payload, content_type, session, opts)
      http_opts.merge!(:method => 'post')
      http_request(http_opts)
    end

    def http_request(http_opts)
      request = RestClient::Request.new(http_opts)
      response = request.execute do |response, request|
        case response.code
        when 200, 201, 202, 204
          return response.body
        when 303
          # 303 See Other, provides a Location header
          # TODO: How do we handle this?
          return response.body
        when 400, 401, 403, 404, 405, 500, 501, 503
          # If there is a body, try to parse as Error XML doc and raise
          # exception.
          if not response.body.strip.empty?
            error = VCloud::Error.from_xml(response.body)
            if error.instance_of?(VCloud::Error)
              raise VCloud::VCloudError.new(
                error.message,
                error.major_error_code,
                error.minor_error_code,
                error.vendor_specific_error_code,
                error.stack_trace)
            end
          end

          # No body was supplied or body wasn't an Error XML doc, create and
          # raise exception.
          major_error_code = response.code
          short_message = VCloud::Errors::HTTPMessage[response.code][:short_message]
          long_message = VCloud::Errors::HTTPMessage[response.code][:message]
          message = "#{short_message} - #{long_message}"

          raise VCloud::VCloudError.new(message, major_error_code)
        else
          raise VCloud::VCloudError.new('An unexpected return code was received', response.code)
        end
      end

      response.nil? ? '' : response.body

    rescue OpenSSL::SSL::SSLError
      raise VCloud::VCloudError.new("Failed to verify SSL certificate at API target URL. Either verify that the target server has a properly named SSL certificate or create the client to skip ssl verification.  Eg: session = VCloud::Client.new('https://api.vcloud.com', '1.5', :verify_ssl => false)", 'na')
    end

    def build_generic_http_opts(url, payload, content_type, session, opts)
      headers = { :accept => VCloud::Constants::ACCEPT_HEADER+";version=#{session.api_version}" }.merge(session.token)
      headers.merge!(:content_type => content_type) if content_type
      {
        :url => url,
        :payload => payload,
        :verify_ssl => session.verify_ssl,
        :headers => headers
      }.merge(opts)
    end

    # Override to provide custom parsing.
    def parse_response(response)
      parse_xml(response.body)
    end
  end
end
