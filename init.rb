require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'cc_addresses_issue_show_hook'
  require_dependency 'redmine_cc_addresses/hooks/view_issues_edit_notes_bottom_hook'
  require_dependency 'redmine_cc_addresses/hooks/controller_issues_edit_before_save_hook'
  require_dependency 'redmine_cc_addresses/hooks/view_issues_history_journal_bottom_hook'

  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineCcAddresses::IssuePatch
    Issue.send(:include, RedmineCcAddresses::IssuePatch)
  end

  require_dependency 'mailer'
  unless Mailer.included_modules.include? RedmineCcAddresses::MailerPatch
    Mailer.send(:include, RedmineCcAddresses::MailerPatch)
  end

  require_dependency 'mail_handler'
  unless MailHandler.included_modules.include? RedmineCcAddresses::MailHandlerPatch
    MailHandler.send(:include, RedmineCcAddresses::MailHandlerPatch)
  end

  config_file = Rails.root + '/config/tickets.yml'
  if File.file?(config_file)
    config = YAML::load_file(config_file)
    if config.is_a?(Hash) && config.has_key?(Rails.env)
      TicketMailer.new_ticket_headers = config[Rails.env]['new_ticket_headers']
    end
  end

end

Redmine::Plugin.register :redmine_cc_addresses do
  name 'Issue CC Addresses'
  author 'Nick Peelman'
  description 'Allows CC Addresses to be attached to an issue'
  version '0.2.0'

  project_module :cc_addresses do |map|    
    map.permission :view_cc_addresses, { }
    map.permission :add_cc_addresses, { :cc_addresses => :create }
    map.permission :delete_cc_addresses, { :cc_addresses => :destroy }    
  end
end
