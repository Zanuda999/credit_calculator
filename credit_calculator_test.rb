ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require './calculator'
require './app'

class CreditCalculator < Minitest::Test

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_shows_page
    get '/'
    assert last_response.ok?
    assert_includes(last_response.body, "Кредитні відомості")
  end

  def test_it_calculates_correctly
    percent = 10
    sum = 100000
    period = 10
    type = 'Equal'
    get "/?percent=#{percent}&sum=#{sum}&type=#{type}&period=#{period}"
    calculator = CALCULATOR_TYPES[type].new
    arr_cr, arr_pr, arr_tr, arr_cb, all_percent, all_sum = calculator.calculate(percent, sum, period)
    (0..period-1).each_with_index do |index|
      assert_includes(last_response.body, arr_cr[index].to_s)
      assert_includes(last_response.body, arr_pr[index].to_s)
      assert_includes(last_response.body, arr_tr[index].to_s)
      assert_includes(last_response.body, arr_cb[index].to_s)
    end
    assert_includes(last_response.body, all_percent.to_s)
    assert_includes(last_response.body, all_sum.to_s)
  end

  def test_it_does_not_pass_validation
    get '/?percent=100q&sum=100000&type=Usual&period=10'
    assert_includes(last_response.body, "Процентна ставка не корректна")
  end

  def test_usual_calculator
    creit_repayment = [33333.33, 33333.33, 33333.33]
    percent_repayment = [833.00, 555.56, 277.78]
    total_repayment = [34166.33, 33888.89, 33611.11]
    credit_balance = [66666.67, 33333.33, 0.00]
    all_percent = 1666.34
    all_sum = 101666.33
    sum = 100000
    period = 3
    percent = 10
    calculator = CALCULATOR_TYPES["Usual"].new
    arr_cr, arr_pr, arr_tr, arr_cb, all_p, all_s = calculator.calculate(percent, sum, period)
    assert_equal(arr_cr, creit_repayment)
    assert_equal(arr_pr, percent_repayment)
    assert_equal(arr_tr, total_repayment)
    assert_equal(arr_cb, credit_balance)
    assert_equal(all_p, all_percent)
    assert_equal(all_s, all_sum)
  end

  def test_equal_calculator
    creit_repayment = [33057.09, 33332.57, 33610.34]
    percent_repayment = [833.33, 557.86, 280.09]
    total_repayment = [33890.43, 33890.43, 33890.43]
    credit_balance = [66942.91, 33610.34, 0.00]
    all_percent = 1671.28
    all_sum = 101671.28
    sum = 100000
    period = 3
    percent = 10
    calculator = CALCULATOR_TYPES["Equal"].new
    arr_cr, arr_pr, arr_tr, arr_cb, all_p, all_s = calculator.calculate(percent, sum, period)
    assert_equal(arr_cr, creit_repayment)
    assert_equal(arr_pr, percent_repayment)
    assert_equal(arr_tr, total_repayment)
    assert_equal(arr_cb, credit_balance)
    assert_equal(all_p, all_percent)
    assert_equal(all_s, all_sum)
  end

end