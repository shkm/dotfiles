autocmd! BufWritePost * Neomake

let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
let g:neomake_rspec_enabled_makers = ['mri', 'rubocop']
let g:neomake_haml_enabled_makers = ['hamllint']

let g:neomake_elixir_enabled_makers = ['elixir', 'credo']

let g:neomake_warning_sign = { 'text': '◈', 'texthl': 'SignColumn' }
let g:neomake_error_sign = { 'text': '✖', 'texthl': 'SignColumn' }
