module Web::Controllers::Index
  # Default covers' urls
  class Covers
    include Web::Action
    def call(_params)
      self.body = { images: covers }.to_json
    end

    def covers
      Dir['./public/static/images/*']
        .sort[0..8]
        .each { |str| str['./public'] = '' }
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
