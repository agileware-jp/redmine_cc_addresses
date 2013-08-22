class TicketMailer < Mailer
  layout false

  def new_ticket(issue, email)
    TicketMailer.new_ticket_headers.each do |k, v|
      headers[k] = v
    end

    redmine_headers 'Project' => issue.project.identifier,
                  'Issue-Id' => issue.id,
                  'Issue-Author' => issue.author.login

    @issue = issue
    @issue_url = url_for(controller: 'issues', action: 'show', id: issue)
    @from = issue.project.email if issue.project.respond_to? :email

    mail(to: email,
         from: @from,
         message_id: issue,
         subject: "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.subject}") do |format|
      format.text
      format.html
    end

  end

  class << self
    def new_ticket_headers=(headers)
      @new_ticket_headers = headers if headers.is_a? Hash
    end

    def new_ticket_headers
      @new_ticket_headers || []
    end
  end
end
