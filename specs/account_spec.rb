require_relative "spec_helper"
require_relative '../lib/account'



describe "Wave 1" do
  describe "Account#initialize" do
    it "Takes an ID and an initial balance" do #this is one test case with 4 assertions

      account = Bank::Account.new({id: 1337, balance: 100.00})

      account.must_respond_to :id
      account.id.must_equal 1337

      account.must_respond_to :balance
      account.balance.must_equal 100.00
    end

    it "Raises an ArgumentError when created with a negative balance" do


      # Note: we haven't talked about procs yet. You can think
      # of them like blocks that sit by themselves.
      # This code checks that, when the proc is executed, it
      # raises an ArgumentError.
      proc {
        Bank::Account.new({id: 1337, balance: -100.0})
      }.must_raise ArgumentError
    end

    it "Can be created with a balance of 0" do

      # If this raises, the test will fail. No 'must's needed!
      Bank::Account.new({id: 1337, balance: 0})
    end
  end

  describe "Account#withdraw" do
    it "Reduces the balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do

      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      updated_balance = account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      updated_balance.must_equal expected_balance
    end

    it "Outputs a warning if the account would go negative" do

      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      # Another proc! This test expects something to be printed
      # to the terminal, using 'must_output'. /.+/ is a regular
      # expression matching one or more characters - as long as
      # anything at all is printed out the test will pass.
      proc {
        account.withdraw(withdrawal_amount)
      }.must_output(/.+/)

    end

    it "Doesn't modify the balance if the account would go negative" do

      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new({id: 1337, balance: start_balance})
      updated_balance = account.withdraw(withdrawal_amount)

      # Both the value returned and the balance in the account
      # must be un-modified.
      updated_balance.must_equal start_balance
      account.balance.must_equal start_balance
    end

    it "Allows the balance to go to 0" do

      account = Bank::Account.new({id: 1337, balance: 100.0})
      updated_balance = account.withdraw(account.balance)
      updated_balance.must_equal 0
      account.balance.must_equal 0
    end

    it "Requires a positive withdrawal amount" do

      start_balance = 100.0
      withdrawal_amount = -25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      proc {
        account.withdraw(withdrawal_amount)
      }.must_raise ArgumentError
    end
  end

  describe "Account#deposit" do
    it "Increases the balance" do

      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do

      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      updated_balance = account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      updated_balance.must_equal expected_balance
    end

    it "Requires a positive deposit amount" do

      start_balance = 100.0
      deposit_amount = -25.0
      account = Bank::Account.new({id: 1337, balance: start_balance})

      proc {
        account.deposit(deposit_amount)
      }.must_raise ArgumentError
    end
  end
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Wave 2" do
  describe "Account.all" do

    before do
      @accounts = Bank::Account.all
    end

    it "Account.all returns an array" do
      @accounts.class.must_equal Array
    end

    # it "Everything in the array is an Account" do
    #
    #   @accounts.each do |account|
    #     account.must_be_instance_of Bank::Account
    #
    #     #@accounts.must_be_instance_of Account
    #     #@accounts.new.must_be_instance_of Account.class
    #   end
    # end

    it "The number of accounts is correct" do
      #Bank::Account.all.length.must_equal 12
      @accounts.length.must_equal CSV.read("support/accounts.csv").count
    end

    it "the ID and balance of the first and last accounts match what's in the CSV file" do
      @accounts[0].id.must_equal 1212
      @accounts[0].balance.must_equal 1235667
      @accounts[11].id.must_equal 15156
      @accounts[11].balance.must_equal 4356772

      # Feel free to split this into multiple tests if needed
    end
  end

  describe "Account.find" do

    before do
      @accounts = Bank::Account.all
    end

    it "Returns an account that exists" do

      account = Bank::Account.find(15155)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 15155
      account.balance.must_equal 999999
      account.opendatetime.must_equal "1990-06-10 13:13:13 -0800"

    end

    it "Can find the first account from the CSV" do
      account = Bank::Account.find(1212)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 1212
      account.balance.must_equal 1235667
      account.opendatetime.must_equal "1999-03-27 11:30:09 -0800"

    end

    it "Can find the last account from the CSV" do
      account = Bank::Account.find(15156)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 15156
      account.balance.must_equal 4356772
      account.opendatetime.must_equal "1994-11-17 14:04:56 -0800"
    end

    it "Raises an error for an account that doesn't exist" do
      proc { Bank::Account.find(15115) }.must_raise ArgumentError
    end
  end
end
