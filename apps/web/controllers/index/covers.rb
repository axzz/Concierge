module Web::Controllers::Index
  # Default covers' urls
  class Covers
    include Web::Action
    def call(_params)
      self.body = { images: covers }.to_json
    end

    private

    def covers
      Dir['./public/static/images/*']
        .sort[0..8]
        .each { |str| str['./public'] = '' }
    end

    def authenticate!
      # skip auth
    end
  end
end
