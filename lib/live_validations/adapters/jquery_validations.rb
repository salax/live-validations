module LiveValidations
  module Adapters
    # Adapter for http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    class JqueryValidations < LiveValidations::Adapter
      validates :presence do |v|
        v.json['required'] = true
      end
  
      validates :length do |v|
        v.json['minlength']   = v.callback.options[:minimum]
        v.json['maxlength']   = v.callback.options[:maximum]
        v.json['range']       = [v.callback.options[:within].first, v.callback.options[:within].last] if v.callback.options[:within]
      end
  
      validates :numericality do |v|
        v.json['digits'] = true
      end
  
      validates :confirmation do |v|
        v.callback.options[:attributes].each do |attribute|
          prefix = v.adapter_instance.active_record_instance.class.name.downcase
          v.raw_json("#{prefix}[#{attribute}_confirmation]" => {'equalTo' => "##{prefix}_#{attribute}"})
        end
      end
  
      validates :format do |v|
        # Probably something like validates_format_of :foo, :with => /bar/, :live_validation => 'js regex here'
      end
  
      validates :uniqueness do |v|
        # Next version. We need to do AJAX callbacks here.
      end
      
      json do |a|
        dom_id = ActionController::RecordIdentifier.dom_id(a.active_record_instance)
        "$('##{dom_id}').validate(#{{'rules' => a.json_data}.to_json})"
      end
    end
  end
end