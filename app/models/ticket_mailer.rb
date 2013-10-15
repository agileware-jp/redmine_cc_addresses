class TicketMailer < ActionMailer::Base
  layout false

  def new_ticket(issue, email)
    TicketMailer.new_ticket_headers.each do |k, v|
      headers[k] = v
    end

    @issue = issue
    @issue_url = url_for(controller: 'issues', action: 'show', id: issue)
    @from = issue.project.email if issue.project.respond_to? :email

    headers = {}
    headers.merge! 'Project' => issue.project.identifier,
                  'Issue-Id' => issue.id,
                  'Issue-Author' => issue.author.login,
                  'X-Mailer' => 'Redmine',
                  'X-Redmine-Host' => Setting.host_name,
                  'X-Redmine-Site' => Setting.app_title,
                  'X-Auto-Response-Suppress' => 'OOF',
                  'Auto-Submitted' => 'auto-generated',
                  'List-Id' => "<#{Setting.mail_from.to_s.gsub('@', '.')}>"

    headers[:to] = email
    headers[:from] = @from
    headers[:subject] = "[#{@issue.project.name} - #{@issue.tracker.name} ##{@issue.id}] #{@issue.subject}"
    headers[:message_id] = issue

    mail headers do |format|
      format.text
      format.html
    end
  end

  def self.default_url_options
    { :host => Setting.host_name, :protocol => Setting.protocol }
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
