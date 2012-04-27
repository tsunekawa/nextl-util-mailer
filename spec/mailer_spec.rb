describe "NextL::Mailer" do
  include Mail::Matchers

  subject { NextL::Mailer.new }
  it { should be_an_instance_of NextL::Mailer }
  its(:issues){ should be_an_instance_of Array }

  describe "#deliver_issues" do
    before :all do
      @mailer = NextL::Mailer.new
      @mailer.deliver_issues(:limit=>0)
      @mail = Mail::TestMailer.deliveries.first
    end

    it { should have_sent_email }
    it { @mail.content_type.should =="text/plain; charset=ISO-2022-JP" }
  end
end
