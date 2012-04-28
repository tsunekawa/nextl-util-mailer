describe "NextL::Mailer" do
  include Mail::Matchers

  subject { NextL::Mailer.new }
  it { should be_an_instance_of NextL::Mailer::Mailer }
  its(:issues){ should be_an_instance_of Array }
  its(:log){
    should be_an_instance_of Array
    should have(0).items
  }

  describe "#deliver_issues" do
    before :all do
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    it { should have_sent_email }
    it { @mailer.log.should have(1).logs }
    it { @mail.content_type.should =="text/plain; charset=ISO-2022-JP" }
  end

  describe "#log" do
    before :all do
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
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    subject { @mailer.latest_log }
    it { should_not be_nil }
    it { should be_an_instance_of Array }
    it { should eq @mailer.log.last }
    it { subject[0].should be_an_instance_of Time }
    it { subject[1].should be_an_instance_of Hash }
    it { subject[1][:from].should_not be_nil }
    it { subject[1][:to].should_not be_nil }
    it { subject[1][:subject].should_not be_nil }
    it { subject[1][:body].should_not be_nil }

  end
end
