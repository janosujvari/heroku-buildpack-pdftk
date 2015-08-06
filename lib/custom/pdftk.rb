class Pdftk < BaseCustom

  def path
    "#{build_path}/vendor/#{name}"
  end

  def name
    "pdftk"
  end

  def source_url
    "https://s3.amazonaws.com/jgtr-heroku/default/pdftk.tar.gz"
  end

  def used?
    File.exist?("#{build_path}/bin/pdftk") && File.exist?("#{build_path}/bin/lib/libgcj.so.12")
  end

  def compile
    write_stdout "compiling #{name}"
    #download the source and extract
    %x{ mkdir -p #{path} && curl --silent #{source_url} -o - | tar -xz -C #{path} -f - } 
    write_stdout "complete compiling #{name}"
    #try to set variables
    write_stdout " adding them into .profile.d/pdftk.sh"
    %x{ echo "export PATH=\\\"/app/vendor/pdftk/bin:\\\$PATH\\\"" > #{build_path}/.profile.d/pdftk.sh } 
    %x{ echo "export LD_LIBRARY_PATH=\\\"/app/vendor/pdftk/lib\\\"" >> #{build_path}/.profile.d/pdftk.sh }
    write_stdout "completed: adding them into .profile.d/pdftk.sh"
  end

  def cleanup!
  end

  def prepare
    File.delete("#{build_path}/bin/lib/libgcj.so.12") if File.exist?("#{build_path}/bin/libgcj.so.12")
    File.delete("#{build_path}/bin/pdftk") if File.exist?("#{build_path}/bin/pdftk")
  end

end
