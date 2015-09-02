require_dependency 'redmine_cc_addresses/hooks/controller_issues_edit_before_save_hook'
require_dependency 'redmine_cc_addresses/hooks/view_issues_edit_notes_bottom_hook'
require_dependency 'redmine_cc_addresses/hooks/view_issues_form_details_bottom_hook'
require_dependency 'redmine_cc_addresses/hooks/view_issues_history_journal_bottom_hook'
require_dependency 'redmine_cc_addresses/hooks/view_issues_show_description_bottom_hook'

Redmine::Plugin.register :redmine_cc_addresses do
  name 'Issue CC Addresses (Customized by RSD)'
  author 'Nick Peelman'
  description 'Allows CC Addresses to be attached to an issue'
  version '0.2.0'

  project_module :cc_addresses do
    permission :view_cc_addresses, { }
    permission :add_cc_addresses, { :cc_addresses => :create }
    permission :delete_cc_addresses, { :cc_addresses => :destroy }
  end
end

ActionDispatch::Reloader.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineCcAddresses::IssuePatch
    Issue.send(:include, RedmineCcAddresses::IssuePatch)
  end

  unless Mailer.included_modules.include? RedmineCcAddresses::MailerPatch
    Mailer.send(:include, RedmineCcAddresses::MailerPatch)
  end

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
