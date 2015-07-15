module RedmineCcAddresses
  module Hooks
    class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, :partial => "issues/cc_addresses/new"
    end
  end
end
