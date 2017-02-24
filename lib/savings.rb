require 'csv'
require 'pry'
require_relative 'account.rb'


module Bank
  class SavingsAccount < Account

    attr_accessor

    def initialize(account)

      @id = account[:id].to_i
      @balance = account[:balance].to_i
      @opendatetime = account[:opendatetime]

      if @balance >= 10
        @balance = @balance
      else
        raise ArgumentError.new "Savings Accounts must have an Initial Balance of $10"
      end

    end

    def withdraw(amount)

      if @balance - (amount + 2)  < 10
        puts "Insufficient Funds"
        return @balance
      else
        @balance = (@balance - (amount + 2)) + 10
        return @balance
      end

    end

    def add_interest(rate)
      if rate < 0
        print "We do not accept negative rates"
        return @balance
      else
        interest = @balance * (rate/100)
        @balance += interest
        return interest
      end
    end


  end
end
