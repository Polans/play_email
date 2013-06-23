class Email

	include Gmail

	FILENAME = 'email_config.yaml'

	def initialize(user=nil, password=nil)
   	if user.nil? and password.nil?
   		data = YAML::load(File.open(FILENAME))
   		user=data['email']
   		password=data['password']
   	end
   	begin
 			@gmail = Gmail.connect!(user,password)
 		rescue Net::IMAP::BadResponseError
 			puts "CANNOT LOGIN TO GMAIL WITH GIVEN CREDENTIALS"
 		end
 	end

 	def connected?
   	@gmail.logged_in?    
 	end

 	def logout
   	@gmail.logout
  end

  def last_inbox_email
  	@gmail.inbox.mails.last
  end

  def last_inbox_unread_email
  	@gmail.inbox.find(:unread).last
  end	

  def last_email_from_label(label_name)
  	@gmail.label(label_name).emails.last
  end

  def last_email_from(from)
  	@gmail.inbox.find(:from => from).last
  end

  def mark_as_unread mail
  	mail.unread!
  end

  def mark_as_read mail
  	mail.read!
  end

  def mark_as_starred mail
  	mail.star!
  end

  def mark_as_unstarred mail
  	mail.unstar!
  end

  def download_attachment mail
  end

  def delete_all_emails_with_label(label)
   	@gmail.emails(:label => label).each do |email|
     	email.delete!
   	end
 	end

  	def emails_with_subject(subject)
    	@gmail.emails(:subject => label)
 		end

 		def send_email(email_to,email_subject,email_body)
    	email = @gmail.compose do
      	to email_to
      	subject email_subject
      	body email_body
    	end
    	email.deliver!
  	end

	end	