# This is more of a monkey patch for Pry.
#
# The intent of this extension is provide a way of expressing
#   binding.pry if some_condition
# without Rubocop complaining or stripping the pry out leaving a bare if statement
class Object
  # Starts a pry session if the passed conditional or block is truthy.
  #
  # == Parameters:
  # flag::
  #   A boolean indicating that we should start a pry session. Can be omitted if using a block
  #
  # object::
  #   Same as the first argument to Pry
  #
  # options::
  #   Same as the second argument to Pry
  #
  def pry_if(flag=nil, object=nil, options={})
    flag = yield if flag.nil? && block_given?
    return unless flag
    require 'pry' unless defined? Pry
    Pry.config.output = STDOUT
    if object.nil? || Hash === object
      Pry.start(self, object || {})
    else
      Pry.start(object, options)
    end
  end
end