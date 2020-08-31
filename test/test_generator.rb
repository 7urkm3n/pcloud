require 'minitest/autorun'

class GeneratorsTest < Minitest::Test
    def test_copy_initializer_file
        dir, file_name = Dir.pwd, "pcloud.rb"
        FileUtils.copy_file "#{dir}/lib/generators/#{file_name}", "#{dir}/test/#{file_name}"
        val1 = File.read(File.join(dir,"/lib/generators/#{file_name}"))
        val2 = File.read(File.join(dir, "/test/#{file_name}"))
        FileUtils.remove_file("#{dir}/test/#{file_name}")
        assert_equal val1, val2
    end
end
