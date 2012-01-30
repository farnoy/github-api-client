module GitHub
  module Version
    Major = 0
    Minor = 4
    Patch = 0
    Build = 'pre'

    String = [Major, Minor, Patch, Build].join('.')
  end
end
