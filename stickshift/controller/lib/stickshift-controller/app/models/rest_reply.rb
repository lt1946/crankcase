class RestReply < StickShift::Model
  attr_accessor :version, :status, :type, :data, :messages, :supported_api_versions

  
  def initialize(status=nil, type=nil, data=nil)
    self.status = status
    self.type = type
    self.data = data
    self.messages = []
    self.version = $requested_api_version.to_s
    self.supported_api_versions = BaseController::SUPPORTED_API_VERSIONS
  end
  
  def process_result_io(result_io)
    unless result_io.nil?
      messages.push(Message.new(:debug, result_io.debugIO.string)) unless result_io.debugIO.string.empty?
      messages.push(Message.new(:info, result_io.messageIO.string)) unless result_io.messageIO.string.empty?
      messages.push(Message.new(:error, result_io.errorIO.string)) unless result_io.errorIO.string.empty?
      messages.push(Message.new(:result, result_io.resultIO.string)) unless result_io.resultIO.string.empty?    
    end
  end
  
  def to_xml(options={})
    options[:tag_name] = "response"
    if not self.data.kind_of?Enumerable
      new_data = self.data
      self.data = [new_data]
    end
    super(options)
  end
end
