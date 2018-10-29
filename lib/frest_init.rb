module FREST
  def self.init
    name = ARGV[1]
    p 'Usage: frest init <name> [<path>]' && quit unless name

    path = ARGV[2] || '.'
    init path: path, name: name

    FileUtils.cp 'template', Pathname.new(path) + name
  end
end
