module RedmineCcAddresses
  # Patches Redmine's Mailer Model dynamically
  module MailerPatch
    def self.included(base) # :nodoc:
      # Same as typing in the class
      base.send(:include, MailerInstanceMethods)
      base.class_eval do
  unloadable
        alias_method_chain :issue_edit, :cc_addresses
        alias_method_chain :issue_add, :cc_addresses
      end
    end
  end

  module MailerInstanceMethods
    def issue_edit_with_cc_addresses(journal, recipients, cc)
      issue = journal.journalized.reload
      issue_edit_without_cc_addresses(journal, recipients, cc)
      unless journal.do_not_send_cc?
        cc_addresses = issue.cc_addresses.collect {|m| m.mail}
        headers[:cc] << cc_addresses
      end
    end
    def issue_add_with_cc_addresses(issue, recipients, cc)
      issue_add_without_cc_addresses(issue, recipients, cc)
      cc_addresses = issue.cc_addresses.collect {|m| m.mail}
      headers[:cc] << cc_addresses
    end
  end
end
