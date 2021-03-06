# frozen_string_literal: true

require 'rubocop/rake_task'

SRC_DIR = 'src'

task default: :walk_the_path

task :walk_the_path do
  cd SRC_DIR
  ruby 'path_to_enlightenment.rb'
end

RuboCop::RakeTask.new(:lint) do |t|
  cd SRC_DIR
  t.options = ['--display-cop-names']
end
