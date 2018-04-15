module Web::Controllers::Index
  # Handle all options requist
  # Explorer will send options requist first
  # When complex requist will send
  class Option
    include Web::Action

    def call(_params)
      self.body = ''
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
