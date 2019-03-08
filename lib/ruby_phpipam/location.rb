module RubyPhpipam
  class Location
    attr_reader :id, :name, :description, :address, :lat, :long, :RHL_ID, :Independent, :custom_Business_Unit

    def initialize(json)
      @id = RubyPhpipam::Helper.to_type(json[:id], :int)
      @name = json[:name]
      @description = json[:description]
      @address = json[:address]
      @lat = json[:lat]
      @long = json[:long]
      @RHL_ID = json[:RHL_ID]
      @Independent = RubyPhpipam::Helper.to_type(json[:Independent], :binary)
      @custom_Business_Unit = json[:custom_Business_Unit]
    end

    def self.get_all
      locations = RubyPhpipam::Query.get_array('/tools/locations/')
      locations.map do |location|
        Location.new(location)
      end
    end

    def self.get(id)
      # phpIPAM API created inconsistency between invalid ID responses
      # thus inconsistency with the wrapper.
      data = RubyPhpipam::Query.get("/tools/locations/#{id}/")
      data ? Location.new(data) : nil
    end

    def subnets(sectionId=nil)
      data = RubyPhpipam::Query.get_array("/tools/locations/#{@id}/subnets/")

      subnets = data.map do |subnet|
        RubyPhpipam::Subnet.new(subnet)
      end

      if sectionId
        subnets.keep_if { |x| x.sectionId == sectionId}
      end

      subnets
    end

  end
end