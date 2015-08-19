require 'sinatra'
require 'sinatra/formkeeper'
require './calculator'

get '/' do
  if params[:period] && params[:sum] && params[:percent] && params[:type]
    form do
      filters :strip
      field :period, :present => true, :int => true
      field :sum, :present => true, :int => true
      field :percent, :present => true, :int => { :between => 0..100 }
      field :type, :present => true
    end
    if form.failed?
      erb :index
    else
      period = form[:period].to_i
      sum = form[:sum].to_f
      percent = form[:percent].to_f
      type = form[:type]
      calculator = CALCULATOR_TYPES[type].new
      arr_credit_repayment, arr_percent_repayment, arr_total_repayment, arr_credit_balance, all_percent, all_sum = calculator.calculate(percent, sum, period)
      erb :result, :locals => {
                     :credit_repayment => arr_credit_repayment,
                     :percent_repayment => arr_percent_repayment,
                     :total_repayment => arr_total_repayment,
                     :credit_balance => arr_credit_balance,
                     :total_percent => all_percent,
                     :total_sum => all_sum,
                     :credit_sum => sum,
                     :period => period,
                     :percent => percent,
                     :type => type
                 }
    end
  else
    erb :index
  end
end