module RedmineCcAddresses
  module MailHandlerPatch
    def self.included(base)
      base.send(:include, MailHandlerInstanceMethods)
      base.class_eval do
        alias_method_chain :receive_issue, :cc_addresses
      end
    end
  end

  module MailHandlerInstanceMethods
    def receive_issue_with_cc_addresses
      issue = receive_issue_without_cc_addresses
      addr = email.from_addrs.to_a.first
      if user.anonymous?
        if addr && !addr.blank?
          issue.cc_addresses << CcAddress.new(mail: addr)
          TicketMailer.new_ticket(issue, addr).deliver
        end
      else
        TicketMailer.new_ticket(issue, user.mail).deliver
      end
      issue
    end
  end
end
