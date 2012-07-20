class UserMailer < ActionMailer::Base
  default from: "christian.brandt@mni.thm.de"

	def invitation_mail(reservation)
		@reservation = reservation
		@url = new_user_path+"?token="+reservation.token
		mail(to: reservation.email, subject: "You have been invited to "+$application_name)
	end
end
