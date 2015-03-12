module GPS
  class Nmea

    def parse_sentance(raw)
      data, type, line = validate_raw(raw)

    	case type
    		when "GGA"
    			data[:last_nmea]    = type
    			data[:time]				  = line.shift
          data[:latitude]     = line.shift
    			data[:lat_ref]			= line.shift
          data[:latitude]     = latLngToDecimal(data[:latitude], data[:lat_ref], true)
          data[:longitude]    = line.shift
    			data[:long_ref]			= line.shift
    			data[:longitude]    = latLngToDecimal(data[:longitude], data[:long_ref], false)
    			data[:quality]			= line.shift
    			data[:num_sat]			= line.shift.to_i
    			data[:hdop]				  = line.shift
    			data[:altitude]			= line.shift
    			data[:alt_unit]			= line.shift
    			data[:height_geoid]		   = line.shift
    			data[:height_geoid_unit] = line.shift
    			data[:last_dgps]		= line.shift
    			data[:dgps]				  = line.shift

        # when "RMC"
        #   data[:last_nmea] = type
        #   data[:time]     = line.shift
        #   data[:validity]   = line.shift
        #   data[:latitude]   = latLngToDecimal(line.shift)
        #   data[:lat_ref]    = line.shift
        #   data[:longitude]  = latLngToDecimal(line.shift)
        #   data[:long_ref]   = line.shift
        #   data[:speed]    = line.shift
        #   data[:course]   = line.shift
        #   data[:date]     = line.shift
        #   data[:variation]  = line.shift
        #   data[:var_direction] = line.shift
        #
        # when "GLL"
        #   data[:last_nmea]  = type
        #   data[:latitude]   = latLngToDecimal(line.shift)
        #   data[:lat_ref]    = line.shift
        #   data[:longitude]  = latLngToDecimal(line.shift)
        #   data[:long_ref]   = line.shift
        #       data[:time]       = line.shift
        #
        # when "RMA"
        #   data[:last_nmea] = type
        #   line.shift # data status
        #   data[:latitude]   = latLngToDecimal(line.shift)
        #   data[:lat_ref]    = line.shift
        #   data[:longitude]  = latLngToDecimal(line.shift)
        #   data[:long_ref]   = line.shift
        #         line.shift # not used
        #         line.shift # not used
        #   data[:speed]      = line.shift
        #   data[:course]     = line.shift
        #   data[:variation]  = line.shift
        #   data[:var_direction]  = line.shift
        #
        # when "GSA"
        #   data[:last_nmea] = type
        #   data[:mode]           = line.shift
        #   data[:mode_dimension] = line.shift
        #
        #       # Satellite data
        #       data[:satellites] ||= []
        #       12.times do |i|
        #         id = line.shift
        #
        #         # No satallite ID, clear data for this index
        #         if id.empty?
        #           data[:satellites][i] = {}
        #
        #         # Add satallite ID
        #         else
        #       data[:satellites][i] ||= {}
        #       data[:satellites][i][:id] = id
        #         end
        #       end
        #
        #       data[:pdop]     = line.shift
        #       data[:hdop]     = line.shift
        #       data[:vdop]     = line.shift
        #
        # when "GSV"
        #   data[:last_nmea]  = type
        #   data[:msg_count]  = line.shift
        #   data[:msg_num]    = line.shift
        #   data[:num_sat]    = line.shift.to_i
        #
        #   # Satellite data
        #         data[:satellites] ||= []
        #   4.times do |i|
        #           data[:satellites][i] ||= {}
        #
        #     data[:satellites][i][:elevation]  = line.shift
        #     data[:satellites][i][:azimuth]    = line.shift
        #     data[:satellites][i][:snr]      = line.shift
        #   end
        #
        #     when "HDT"
        #   data[:last_nmea] = type
        #   data[:heading]  = line.shift
        #
        # when "ZDA"
        #   data[:last_nmea] = type
        #   data[:time] = line.shift
        #
        #   day   = line.shift
        #   month = line.shift
        #   year  = line.shift
        #   if year.size > 2
        #     year = [2, 2]
        #   end
        #   data[:date] = "#{day}#{month}#{year}"
        #
        #   data[:local_hour_offset]    = line.shift
        #   data[:local_minute_offset]  = line.shift
    	end

    	# Remove empty data
    	data.each_pair do |key, value|
    		if value.nil? || (value.is_a?(String) && value.empty?)
    			data.delete(key)
    		end
    	end

    	data
    end

    def parse_raw(raw)
      raw
    end

    private

    def latLngToDecimal(coord, dir, lat)
    	coord = coord.to_s
    	decimal = nil
    	if (lat && dir.to_s.upcase == "S") || dir.to_s.upcase == "W"
    	  negative = true
    	end

    	# Find parts
    	if coord =~ /^-?([0-9]*?)([0-9]{2,2}\.[0-9]*)$/
    		deg = $1.to_i # degrees
    		min = $2.to_f # minutes & seconds

    		# Calculate
    		decimal = deg + (min / 60)
    		if negative
    			decimal *= -1
    		end
    	end
    	decimal
    end

    def validate_raw(raw)
      data = { :last_nmea => nil }
    	if raw.nil?
    		return data
    	end

      line = raw.encode('utf-8', invalid: :replace).split(",")

      unless raw.valid_encoding?
        return data
      end

    	line = raw.split(",")
    	if line.size < 1
    		return data
    	end

    	# Invalid sentence, does not begin with '$'
    	if line[0][0, 1] != "$"
    		return data
    	end

    	# Parse sentence
    	type = line[0][3, 3]
    	line.shift

    	if type.nil?
    		return data
    	end
    	[data,type,line]
    end
  end
end
