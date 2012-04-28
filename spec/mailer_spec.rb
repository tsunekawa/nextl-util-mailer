describe "NextL::Mailer" do
  include Mail::Matchers

  before :all do
    Redis.current.flushdb
  end

  subject { NextL::Mailer.new }
  it { should be_an_instance_of NextL::Mailer::Mailer }
  its(:issues){ should be_an_instance_of Array }
  its(:log){
    should be_an_instance_of Array
    should have(0).items
  }

  describe "#deliver_issues" do
    before :all do
      Redis.current.flushdb
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    it { should have_sent_email }
    it { @mailer.log.should have(1).logs }
    it { @mail.content_type.should =="text/plain; charset=ISO-2022-JP" }
  end
end
