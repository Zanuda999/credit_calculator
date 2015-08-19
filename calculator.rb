require 'interface'

CalculatorInterface = interface{
  required_methods :calculate
}


class StandartCalculator

  def calculate(percent, sum, period)
    arr_credit_repayment = []
    arr_percent_repayment = []
    arr_total_repayment = []
    arr_credit_balance = []
    mp_cnt = period * 1.0
    rest = sum
    mp_real = sum / mp_cnt
    until mp_cnt == 0 do
      mp = mp_real + (rest * percent / 1200)
      arr_credit_repayment.push(mp_real.round(2))
      arr_total_repayment.push(mp.round(2))
      arr_percent_repayment.push((mp - mp_real).round(2))
      rest = rest - mp_real
      arr_credit_balance.push(rest.round(2))
      mp_cnt = mp_cnt - 1
    end
    return arr_credit_repayment, arr_percent_repayment, arr_total_repayment, arr_credit_balance, arr_percent_repayment.inject(:+).round(2), arr_total_repayment.inject(:+).round(2)
  end

  implements CalculatorInterface

end


class AnnuityCalculator

  def calculate(percent, sum, period)
    arr_credit_repayment = []
    arr_percent_repayment = []
    arr_total_repayment = []
    arr_credit_balance = []
    credit_balance = sum
    mp_cnt = period * 1.0
    r = percent / 1200.0
    ak = (r * (1 + r) ** mp_cnt) / (((1 + r) ** mp_cnt) - 1)
    mp = (sum * ak)
    total = mp * mp_cnt
    until mp_cnt == 0 do
      percent_repayment = credit_balance*percent/1200.0
      credit_repayment = mp - percent_repayment #.round(2)
      arr_percent_repayment.push(percent_repayment.round(2))
      arr_credit_repayment.push(credit_repayment.round(2))
      arr_total_repayment.push(mp.round(2))
      credit_balance -= credit_repayment
      arr_credit_balance.push(credit_balance.round(2))
      mp_cnt -= 1
    end
    total_percent = total - sum
    return arr_credit_repayment, arr_percent_repayment, arr_total_repayment, arr_credit_balance, total_percent.round(2), total.round(2)
  end

  implements CalculatorInterface
end

CALCULATOR_TYPES = { "Usual" => StandartCalculator, "Equal" => AnnuityCalculator }
