module Web::Controllers::Index
  # Default covers' urls
  class Covers
    include Web::Action
    def call(_params)
      self.body = { images: covers }.to_json
      puts Time.now.to_f
      puts 11111111111
    end

    private

    def covers
      [
        '/static/images/img0.jpg',
        '/static/images/img1.jpg',
        '/static/images/img2.png',
        '/static/images/img3.jpg',
        '/static/images/img4.jpg',
        '/static/images/img5.jpg',
        '/static/images/img6.jpg',
        '/static/images/img7.jpg',
        '/static/images/img8.jpg',
      ]
      # Dir['./public/static/images/*']
      #   .sort[0..8]
      #   .each { |str| str['./public'] = '' }
    end

    def authenticate!
      # skip auth
    end
  end
end
