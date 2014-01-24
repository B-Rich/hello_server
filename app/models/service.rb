class Service
  include DataMapper::Resource
  storage_names[:default] = "services"

  property :id, Serial, key: true
  property :name, String, length: 32, required: true
  property :value, Json

  timestamps :at

  def self.find_or_initialize_by_name(name)
    s = Service.first(name: name)
    if s.nil?
      s = Service.new
      s.name = name
    else
      s = Service.get(s.id) # WTF?
    end
    return s
  end
end