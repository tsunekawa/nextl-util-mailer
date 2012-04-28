describe "NextL::Mailer" do
  describe "#log" do
    before :all do
      Redis.current.flushdb
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    subject { @mailer.log }
    it { should be_an_instance_of Array }
    it {
      subject.each do |record|
        record.should be_an_instance_of Array
        record[0].should be_an_instance_of Time
	record[1].should be_an_instance_of Hash
	record[1][:from].should_not be_nil
	record[1][:to].should_not be_nil
	record[1][:subject].should_not be_nil
	record[1][:body].should_not be_nil
      end
    }
  end

  describe "#latest_log" do
    before :all do
      Redis.current.flushdb
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    subject { @mailer.latest_log }
    it { should_not be_nil }
    it { should be_an_instance_of Array }
    it { subject[0].should == @mailer.log.last[0] }
    it { subject[0].should be_an_instance_of Time }
    it { subject[1].should be_an_instance_of Hash }
    it { subject[1][:from].should_not be_nil }
    it { subject[1][:to].should_not be_nil }
    it { subject[1][:subject].should_not be_nil }
    it { subject[1][:body].should_not be_nil }

  end

  context "after forwarding issues once" do
    before :all do
      Redis.current.flushdb
      Mail::TestMailer.deliveries.clear
      @mailer = NextL::Mailer.new
      @mailer.stub!(:latest_log).and_return([
	Time.now,
	{:from=>"from@example.com", :to=>"to@example.com", :body=>"test"}
      ])
      @mailer.deliver_issues(:limit=>5)
      @mails = Mail::TestMailer.deliveries
    end

    it "no messages forwarded if mailer has checked now" do
      @mails.should have(0).messages
    end

  end
end
