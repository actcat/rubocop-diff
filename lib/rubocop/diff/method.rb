require 'ripper'

class Rubocop::Diff::Method
  class InvalidAST < ArgumentError; end

  # @param [String] definition
  #
  # Definition Example:
  #   def f(a, b, c, m = 1, n = 1, *rest, x, y, z, k: 1, **kwrest, &blk)
  #
  # AST Example:
  #   [:program,
  #    [[:def,
  #      [:@ident, "f", [1, 4]],
  #      [:paren,
  #       [:params,
  #        [[:@ident, "a", [1, 6]], [:@ident, "b", [1, 9]], [:@ident, "c", [1, 12]]],
  #        [[[:@ident, "m", [1, 15]], [:@int, "1", [1, 19]]], [[:@ident, "n", [1, 22]], [:@int, "1", [1, 26]]]],
  #        [:rest_param, [:@ident, "rest", [1, 30]]],
  #        [[:@ident, "x", [1, 36]], [:@ident, "y", [1, 39]], [:@ident, "z", [1, 42]]],
  #        [[[:@label, "k:", [1, 45]], [:@int, "1", [1, 48]]]],
  #        [:@ident, "kwrest", [1, 53]],
  #        [:blockarg, [:@ident, "blk", [1, 62]]]]],
  #      [:bodystmt, [[:void_stmt]], nil, nil, nil]]]]
  #
  def initialize(definition)
    code = "#{definition}; end"
    ast = Ripper.sexp(code)

    begin
      params = ast[1][0][2]
      name = ast[1][0][1][1]
    rescue NoMethodError => ex
      raise InvalidAST, "Can't parse AST. \nAST: #{ast}\nError: #{ex}"
    end

    if params[0] == :paren
      params = params[1]
    end

    @params = params[1..-1]
    @name = name
  end

  # TODO: もっとマシにする
  # @param [Array<RuboCop::Node>] args
  def callable?(name, args)
    return false unless name == @name

    args = args.dup

    # 通常の引数分shift
    # TODO: shift 出来るかをちゃんと判定
    return false unless args.shift(normal_params.size).size == normal_params.size

    unless has_keyword_params?
      return false unless args.pop(normal_params_after_rest.size).size == normal_params_after_rest.size
    end

    # デフォルト値付き引数

    # rest 引数

    # rest 引数後の通常引数

    # キーワード引数
    # XXX: キーワード引数にはデフォルト値付き引数がある

    # キーワード rest 引数
    # これがあれば、キーワード引数は何でも受け付けるようになる(flag)

    # ブロックは無視

    args.empty?
  end


  private

  def has_keyword_params?
    !!((keyword_params && !keyword_params.empty?) ||
      keyword_rest_params)
  end

  %i[
    normal_params
    default_value_params
    rest_params
    normal_params_after_rest
    keyword_params
    keyword_rest_params
  ].each.with_index do |name, idx|
    eval <<-CODE
def #{name}
  @params[#{idx}]
end
    CODE
  end
end
