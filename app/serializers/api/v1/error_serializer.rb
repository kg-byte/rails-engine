class Api::V1::ErrorSerializer
  def self.format_error(message)
    {data: 
          {error:  message }
    }
  end


  def self.val_error(message)
    format_error(message)[:data]
  end

end
