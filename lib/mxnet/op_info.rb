module MXNet
  OpInfo = Struct.new(:name, :real_name, :description, :args, :key_var_num_args, :return_type)
  OpArgInfo = Struct.new(:name, :type_info, :description)

  class OpInfo
    NAME_PREFIX_LIST = %w[
      _contrib_
      _linalg_
      _sparse_
    ].freeze

    def name_prefix
      NAME_PREFIX_LIST.each do |prefix|
        return prefix if name.to_s.start_with?(prefix)
      end
      ''
    end

    def func_name
      @func_name ||= calculate_func_name
    end

    def module_name
      prefix = name_prefix
      case
      when prefix.length > 0
        prefix[1..-2].capitalize.to_sym
      when name.to_s.start_with?('_')
        :Internal
      else
        :Ops
      end
    end

    private

    def calculate_func_name
      prefix = name_prefix
      case
      when prefix.length > 0
        name[prefix.length..-1].to_sym
      else
        name.to_sym
      end
    end
  end
end
