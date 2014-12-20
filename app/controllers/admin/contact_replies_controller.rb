class Admin::ContactRepliesController < AdminController
  inherit_resources
  # before_filter :only => :show do
  #   redirect_to admin_contact_replies_path
  # end

  def create
    create!{
      email = resource.contact.email
      subject = "RE:" + resource.contact.title
      body = resource.content

      ActionMailer::Base.mail(:to => email,:subject => subject, :body => body,:from => "notification@tempot.com").deliver

      admin_contact_replies_path
    }
  end
end
