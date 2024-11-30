local rails_utils = require('rails-utils')

return {
  { "<A-t>", rails_utils.find_template_render, desc = "Find template in views" },
  { "<A-v>", rails_utils.find_template,        desc = "Views" },
  { "<C-s>", rails_utils.alternate,            desc = "Find Spec" },
}
