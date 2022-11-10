class PasswordlessMailerPreview < ActionMailer::Preview
  def magic_link
    session = Passwordless::Session.first
    Passwordless::Mailer.magic_link(session).deliver_now
  end
end
