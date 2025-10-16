require "spec_helper"

describe OFX::Statement do
  let(:parser) { ofx.parser }
  let(:statement) { parser.statements.first }
  let(:parser_one_line) { ofx_one_line.parser }
  let(:statement_one_line) { parser_one_line.statements.first }

  context "Bank Account" do
    let(:ofx) { OFX::Parser::Base.new("spec/fixtures/sample.ofx") }
    let(:ofx_one_line) { OFX::Parser::Base.new("spec/fixtures/sample_one_line.ofx") }
    it "returns currency" do
      statement.currency.should == "BRL"
      statement_one_line.currency.should == "BRL"
    end

    it "returns start date" do
      statement.start_date.should == Time.parse("2009-10-09 08:00:00 +0000")
      statement_one_line.start_date.should == Time.parse("2009-10-09 08:00:00 +0000")
    end

    it "returns end date" do
      statement.end_date.should == Time.parse("2009-11-03 08:00:00 +0000")
      statement_one_line.end_date.should == Time.parse("2009-11-03 08:00:00 +0000")
    end

    it "returns account" do
      statement.account.should be_a(OFX::Account)
      statement.account.id.should == '03227113109'
      statement.account.type.should == :checking

      statement_one_line.account.should be_a(OFX::Account)
      statement_one_line.account.id.should == '03227113109'
      statement_one_line.account.type.should == :checking
    end

    it "returns transactions" do
      statement.transactions.should be_a(Array)
      statement.transactions.size.should == 36

      statement_one_line.transactions.should be_a(Array)
      statement_one_line.transactions.size.should == 36
    end

    describe "balance" do
      let(:balance) { statement.balance }
      let(:balance_one_line) { statement_one_line.balance }
      it "returns balance" do
        balance.amount.should == BigDecimal('598.44')
        balance_one_line.amount.should == BigDecimal('598.44')
      end

      it "returns balance in pennies" do
        balance.amount_in_pennies.should == 59844
        balance_one_line.amount_in_pennies.should == 59844
      end

      it "returns balance date" do
        balance.posted_at.should == Time.parse("2009-11-01 00:00:00 +0000")
        balance_one_line.posted_at.should == Time.parse("2009-11-01 00:00:00 +0000")
      end
    end

    describe "available_balance" do
      let(:available_balance) { statement.available_balance }
      let(:available_balance_one_line) { statement_one_line.available_balance }

      it "returns available balance" do
        available_balance.amount.should == BigDecimal('1555.99')
        available_balance_one_line.amount.should == BigDecimal('1555.99')
      end

      it "returns available balance in pennies" do
        available_balance.amount_in_pennies.should == 155599
        available_balance_one_line.amount_in_pennies.should == 155599
      end

      it "returns available balance date" do
        available_balance.posted_at.should == Time.parse("2009-11-01 00:00:00 +0000")
        available_balance_one_line.posted_at.should == Time.parse("2009-11-01 00:00:00 +0000")
      end

      context "when AVAILBAL not found" do
        let(:ofx) { OFX::Parser::Base.new("spec/fixtures/utf8.ofx") }

        it "returns nil " do
          available_balance.should be_nil
        end
      end
    end
  end

  context "Credit Card" do
    let(:ofx) { OFX::Parser::Base.new("spec/fixtures/creditcard.ofx") }
    let(:ofx_one_line) { OFX::Parser::Base.new("spec/fixtures/creditcard_one_line.ofx") }

    it "returns currency" do
      statement.currency.should == "USD"
      statement_one_line.currency.should == "USD"
    end

    it "returns start date" do
      statement.start_date.should == Time.parse("2007-05-09 12:00:00 +0000")
      statement_one_line.start_date.should == Time.parse("2007-05-09 12:00:00 +0000")
    end

    it "returns end date" do
      statement.end_date.should == Time.parse("2007-06-08 12:00:00 +0000")
      statement_one_line.end_date.should == Time.parse("2007-06-08 12:00:00 +0000")
    end

    it "returns account" do
      statement.account.should be_a(OFX::Account)
      statement.account.id.should == 'XXXXXXXXXXXX1111'

      statement_one_line.account.should be_a(OFX::Account)
      statement_one_line.account.id.should == 'XXXXXXXXXXXX1111'
    end

    it "returns transactions" do
      statement.transactions.should be_a(Array)
      statement.transactions.size.should == 3

      statement_one_line.transactions.should be_a(Array)
      statement_one_line.transactions.size.should == 3
    end

    describe "balance" do
      let(:balance) { statement.balance }
      let(:balance_one_line) { statement_one_line.balance }

      it "returns balance" do
        balance.amount.should == BigDecimal('-1111.01')

        balance_one_line.amount.should == BigDecimal('-1111.01')
      end

      it "returns balance in pennies" do
        balance.amount_in_pennies.should == -111101
        balance_one_line.amount_in_pennies.should == -111101
      end

      it "returns balance date" do
        balance.posted_at.should == Time.parse("2007-06-23 19:20:13 +0000")
        balance_one_line.posted_at.should == Time.parse("2007-06-23 19:20:13 +0000")
      end
    end

    describe "available_balance" do
      let(:available_balance) { statement.available_balance }
      let(:available_balance_one_line) { statement_one_line.available_balance }

      it "returns available balance" do
        available_balance.amount.should == BigDecimal('19000.99')
        available_balance_one_line.amount.should == BigDecimal('19000.99')
      end

      it "returns available balance in pennies" do
        available_balance.amount_in_pennies.should == 1900099
        available_balance_one_line.amount_in_pennies.should == 1900099
      end

      it "returns available balance date" do
        available_balance.posted_at.should == Time.parse("2007-06-23 19:20:13 +0000")
        available_balance_one_line.posted_at.should == Time.parse("2007-06-23 19:20:13 +0000")
      end
    end
  end
end
