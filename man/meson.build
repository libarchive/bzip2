install_man('bzip2.1', 'bzgrep.1', 'bzdiff.1', 'bzmore.1')

# Install copies of some of the man files
man1dir = join_paths(get_option('prefix'), get_option('mandir'), 'man1')
foreach m : [['bzip2.1', ['bunzip2.1', 'bzcat']],
             ['bzgrep.1', ['bzegrep.1', 'bzfgrep.1']],
             ['bzmore.1', ['bzless.1']],
             ['bzdiff.1', ['bzcmp.1']]]
  _input = m[0]
  foreach o : m[1]
    configure_file(
      input : _input,
      output : o,
      copy : true,
      install : true,
      install_dir : man1dir,
    )
  endforeach
endforeach
