require'rails-utils'.setup({
  command = { "docker", "exec", "spabreaks-test-1", "bin/rspec", "--format", "j" },
})
