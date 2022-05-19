module EdgeCasesHelper 

  def edge_cases_conditions
    negative_max || negative_min || no_params || empty_params || name_and_price || max_less_than_min
  end

  def edge_case_resposne
    return render json: Api::V1::ErrorSerializer.val_error(error_messages[:max_val]), status:400 if negative_max 
    return render json: Api::V1::ErrorSerializer.val_error(error_messages[:min_val]), status:400 if negative_min 
    return render json: Api::V1::ErrorSerializer.format_error(error_messages[:missing_param]), status: 400 if no_params 
    return render json: Api::V1::ErrorSerializer.format_error(error_messages[:empty_param]), status: 400 if empty_params 
    return render json: Api::V1::ErrorSerializer.format_error(error_messages[:name_price]), status: 400 if name_and_price
    return render json: Api::V1::ErrorSerializer.format_error(error_messages[:max_less_than_min]), status: 400 if max_less_than_min 
  end

  def error_messages
    messages = Hash.new 
    messages[:max_val]='max_price cannot be negative'
    messages[:min_val]='min_price cannot be negative'
    messages[:missing_param]='Parameter cannot be missing'
    messages[:empty_param] = 'Parameter cannot be empty'
    messages[:name_price]='Cannot send both name and price'
    messages[:max_less_than_min]='max_price cannot be less than min_price'
    messages
  end
   
end