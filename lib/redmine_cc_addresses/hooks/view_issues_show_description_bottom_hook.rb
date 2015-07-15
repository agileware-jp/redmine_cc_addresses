module RedmineCcAddresses
  module Hooks
    class ViewIssuesShowDescriptionBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_description_bottom, :partial => "issues/cc_addresses"
    end
  end
end
