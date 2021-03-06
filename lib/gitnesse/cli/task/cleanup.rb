require 'etc'

Gitnesse::Cli.task :cleanup do
  desc "Cleans up project folders in ~/.gitnesse"

  help do
    <<-EOS
USAGE: gitnesse cleanup

#{desc}

Cleans up the folders for local copies of wikis Gitnesse leaves in ~/.gitnesse.

Examples:
  gitnesse cleanup  # will remove all subfolders from ~/.gitnesse
    EOS
  end

  def perform
    confirm
    delete_folders
    puts "  Done."
  end

  def confirm
    @folders = Dir["#{Dir.home(Etc.getlogin)}/.gitnesse/*"]
    @folders.reject! { |f| f =~ /\/\_features/ }

    unless @folders.any?
      abort "  No folders to delete."
    end

    puts "  This will delete the following folders:"

    @folders.each do |folder|
      puts "    - #{folder}"
    end

    puts "  Please confirm (y|n):"
    begin
      until %w( k ok y yes n no ).include?(answer = $stdin.gets.chomp.downcase)
        puts '  Please type y/yes or n/no.'
        puts '  Remove folders? (y|n)'
      end
    rescue Interrupt
      abort
    end

    abort if answer =~ /n/
  end

  def delete_folders
    @folders.each do |folder|
      puts "  Deleting #{folder}."
      FileUtils.rm_rf(folder)
    end
  end
end
