require 'magic_path'

MagicPath.create_path :fixture_path, { pattern: ':fixture_root' }
MagicPath.create_path :fixture_file_base, { pattern: ':filename:ext' }
MagicPath.create_path :fixture_file_env, { pattern: ':filename.:test_env:ext' }
