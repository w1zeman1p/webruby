# This file configures mruby to cross compile the emscripten version
# We expose this file here to let users adding mrbgems using the same
# method as in mruby

CURRENT_DIR = File.dirname(File.expand_path(__FILE__))
EMSCRIPTEN_DIR = ENV['EMSCRIPTEN_DIR'] || File.join(CURRENT_DIR, %w[modules emscripten])

# Native mruby build config for mrbc
MRuby::Build.new do |conf|
  # load specific toolchain settings
  toolchain :gcc

  conf.gembox 'default'
end


# Emscripten customized toolchain
MRuby::Toolchain.new(:emscripten) do |conf|
  toolchain :clang

  conf.cc do |cc|
    cc.command = File.join(EMSCRIPTEN_DIR, 'emcc')
    cc.flags = (ENV['CFLAGS'] || %w(-Wall -Werror-implicit-function-declaration))
  end

  conf.linker.command = File.join(EMSCRIPTEN_DIR, 'emcc')
  conf.archiver.command = File.join(EMSCRIPTEN_DIR, 'emar')
end

# Cross build for emscripten, adding your mrbgems here.
MRuby::CrossBuild.new('emscripten') do |conf|
  toolchain :emscripten

  # 'default' gembox does not include mruby-eval, which would otherwise bring
  # all parsing code. We do not include this gem here to ensure the parsing code
  # will be stripped in LOADING_MODE 0 and 1. Feel free to uncomment the eval
  # line below if you want to use it.
  conf.gembox 'default'

  # You can add new mrbgem at here!
  # A few commonly used gems are listed here(but commented),
  # you can simply uncomment the corresponding lines if you want to use them.

  # mruby-eval gem, all parsing code will be packed into the final JS!
  # conf.gem :core => "mruby-eval"

  # JavaScript calling interface
  # conf.gem :git => 'git://github.com/xxuejie/mruby-js.git', :branch => 'master'

  # OpenGL ES 2.0 binding
  # conf.gem :git => 'git://github.com/xxuejie/mruby-gles.git', :branch => 'master'

  # Normally we wouldn't use this example gem, I just put it here to show how to
  # add a gem on the local file system, you can either use absolute path or relative
  # path from mruby root, which is modules/webruby.
  # conf.gem "#{root}/examples/mrbgems/c_and_ruby_extension_example"
end
