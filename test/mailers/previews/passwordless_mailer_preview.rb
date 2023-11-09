class PasswordlessMailerPreview < ActionMailer::Preview
  def sign_in
    user = User.build(email: 'foo@bar.com')
    session = Passwordless::Session.create!(authenticatable: user)
    Passwordless::Mailer.sign_in(session)
  end
end
